//
//  MapViewController.swift
//  KickboardApp
//
//  Created by 임혜정 on 7/22/24.
//

import UIKit
import SnapKit
import KakaoMapsSDK
import CoreLocation
import Alamofire

class MapViewController: UIViewController, MapControllerDelegate, SearchMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var selectedPoi: Poi?
    var mapView: MapView!
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var poiPositions: [MapPoint] = []
    private var isMapInit = false
    
    override func loadView() {
        mapView = MapView()
        view = mapView
    }
    
    func addViews() {
        guard !isMapInit else { return }
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: 126.9137, latitude: 37.5491)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 17)
        
        mapContainer = mapView?.mapView
        
        print("1맵 컨테이너 생성 성공")
        
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
        
        print("2mapController 초기화 성공")
        
        mapController?.prepareEngine()
        print("3 prepareEngine 성공")
        DispatchQueue.main.async {
            self.mapController?.addView(mapviewInfo)
        }
        print("4단계 뷰 로드 완")
        // ❗️메인스레드에서 실행하고자 디스패치큐를 사용했으나 이로인해 뷰로드 순서가 꼬여서 때때로 맵 로드가 제대로 되지 않을 수 있음, 테스트 중...
        
        isMapInit = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setLocation()
        setupMyLocationButton()
        setupStopReturnButton()
        updateStopReturnButtonState()
        generateRandomPoiPositions()
            SearchMapView().setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapController?.activateEngine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapController?.pauseEngine()  //렌더링 중지.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()
        //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
    }
    
    
    // 지도 API 인증 실패 시 처리
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode), desc: \(desc)")
        
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("인증 실패 5초뒤에 재인증 시도")
                self.mapController?.prepareEngine()
            }
        default: showToast(self.view, message: "알 수 없는 오류")
            
        }
    }
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
        createPoiStyle()
        createLabelLayer()
        createPoi()
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func willResignActive(){
        mapController?.pauseEngine()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }
    
    @objc func didBecomeActive(){
        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
    
    //authenticationFailed 메서드에서 인증 실패 시 사용자에게 피드백되는 부분
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 0.4,
                       delay: duration - 0.4,
                       options: .curveEaseOut,
                       animations: {
            toastLabel.alpha = 0.0
        },
                       completion: { (finished) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    //   좌표모델.
    private func generateRandomPoiPositions() {
        let numberOfPois = 50
        poiPositions = (0..<numberOfPois).map { _ in
            let longitude = Double.random(in: 126.910...126.916)
            let latitude = Double.random(in: 37.545...37.551)
            return MapPoint(longitude: longitude, latitude: latitude)
        }
    }
    
    
    
    
    //MARK: - 현재 위치 파악
    private func setupMyLocationButton() {
        guard let myLocationButton = mapView?.myLocationButton else {
            print("myLocationButton is nil")
            return
        }
        myLocationButton.addTarget(self, action: #selector(myLocationButtonTapped), for: .touchUpInside)
    }
    private func setupStopReturnButton() {
        guard let stopReturnButton = mapView?.stopReturnButton else {
            print("stopReturnButton is nil")
            return
        }
        stopReturnButton.addTarget(self, action: #selector(stopReturnButtonTapped), for: .touchUpInside)
        updateStopReturnButtonState()
    }
    
    private func updateStopReturnButtonState() { // poi버튼이 선택된 상황인지에 따른
        mapView?.stopReturnButton.isEnabled = (selectedPoi != nil)
    }
    private func deselectCurrentPoi() {
        if let poi = selectedPoi {
            poi.changeStyle(styleID: "blue")
            selectedPoi = nil
            updateStopReturnButtonState()
        }
    }
    
    @objc func myLocationButtonTapped() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            moveCameraToCurrentLocation(location.coordinate)
        }
    }
    
    @objc func stopReturnButtonTapped() {
        guard selectedPoi != nil else { return }
        // 윤대성 여기에 타임스탑,모달팝업 등의 동작을 넣으세요
        print("마커가 선택되었당")
        // 작업 완료 후 선택 상태 초기화
        deselectCurrentPoi()
    }
    
    private func setLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    
    
    //MARK: SearchMapView - sh
    
    
    // delegate 필수함수 - sh
    func didSearchAddress(_ documents: String) {
        //            guard _auth else {
        //                print("인증상태 없음")
        //                return
        //            }
        
        // 주소검색 및 지도이동 처리 - sh
        searchAddress(documents) { result in
            switch result {
            case .success(let documents):
                // 첫 번째 documents값에서 위도와 경도 가져오기
                if let documents = documents.first, let latitude = Double(documents.latitude), let longitude = Double(documents.longitude) {
                    self.updateMapView(latitude: latitude, longitude: longitude)
                } else {
                    print("Address 데이터 오류")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    // 주소 찾기 메서드 - sh
    private func searchAddress(_ address: String, completion: @escaping (Result<[Address], Error>) -> Void) {
        let apiKey = "aac47a0eaf15cc563a8993c289fdd10f"
        let encodedQuery = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = "https://dapi.kakao.com/v2/local/search/address.json?query=\(encodedQuery!)"
        
        guard let url = URL(string: urlString) else {
            print("URL 오류")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK \(apiKey)"
        ]
        
        // NetworkManager 함수 사용
        NetworkManager.shared.fetchData(url: url, headers: headers) { (result: Result<SearchedAddress, AFError>) in
            switch result {
            case .success(let searchedAddress):
                completion(.success(searchedAddress.documents))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 주소검색에서 가져온 위도, 경도 데이터 이용해 지도 이동하는 메서드 - sh
    private func updateMapView(latitude: Double, longitude: Double) {
        guard !latitude.isNaN, !longitude.isNaN else {
            print("위도 경도 데이터 오류")
            // 오류 Alert 추가예정
            return
        }
        
        let position = MapPoint(longitude: longitude, latitude: latitude)
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            print("맵뷰 로드 실패")
            // 오류 Alert 추가예정
            return
        }
        //            mapView.moveCamera(CameraUpdate.make(target: position, zoomLevel: 15, mapView: mapView))
        //            createPoi(at: position)
    }
    
    
    
    
}












//MARK: - POI
extension MapViewController: KakaoMapEventDelegate {
    func createPoiStyle() { // 보이는 스타일 정의
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        let image = UIImage(named: "pin_blue.png")
        let icon = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
        let poiStyle = PoiStyle(styleID: "blue", styles: [perLevelStyle])
        labelManager.addPoiStyle(poiStyle)
        
        // 클릭된 상태의 스타일 추가
        let clickedImage = UIImage(named: "pin_red.png") // 클릭 시 변경될 이미지
        let clickedIcon = PoiIconStyle(symbol: clickedImage, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let clickedPerLevelStyle = PerLevelPoiStyle(iconStyle: clickedIcon, level: 0)
        let clickedPoiStyle = PoiStyle(styleID: "clicked", styles: [clickedPerLevelStyle])
        labelManager.addPoiStyle(clickedPoiStyle)
    }
    
    func createLabelLayer() { // 레이어생성
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let labelManager = mapView.getLabelManager()
        let layer = LabelLayerOptions(layerID: "poiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = labelManager.addLabelLayer(option: layer)
    }
    
    func createPoi() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: "poiLayer") else {
            return
        }
        for (index, position) in poiPositions.enumerated() {
            let options = PoiOptions(styleID: "blue", poiID: "bluePoi_\(index)")
            options.clickable = true
            if let poi = layer.addPoi(option: options, at: position) {
                poi.show()
                // POI 클릭 이벤트 핸들러 추가
                let _ = poi.addPoiTappedEventHandler(target: self) { [weak self] _ in
                    return { param in
                        self?.poiTapped(param)
                    }
                }
            }
        }
    }
    
    func poiTapped(_ param: PoiInteractionEventParam) {
        guard let poi = param.poiItem as? Poi else { return }
        
        // 이전에 선택된 POI가 있다면 스타일 변경
        deselectCurrentPoi()
        
        // 새로운 POI 선택
        selectedPoi = poi
        poi.changeStyle(styleID: "clicked")
        
        // Stop/Return 버튼 상태 업데이트
        updateStopReturnButtonState()
        
        // 정보 표시
        let alert = UIAlertController(title: "위치 정보", message: "\n위치: \(poi.position)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            // 알림창을 닫아도 POI는 선택된 상태로 유지
        })
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - 사용자 위치 관련
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("권한 설정됨")
            locationManager.startUpdatingLocation()
        case .notDetermined:
            print("권한 설정되지 않음")
        case .restricted, .denied:
            print("권한 요청 거부됨")
        @unknown default:
            print("알 수 없는 위치")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보를 가져오는데 실패했습니다: \(error.localizedDescription)")
        
        // 사용자에게 오류 메시지를 표시
        showToast(self.view, message: "위치 정보를 가져오는데 실패했습니다.")
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("위치 서비스가 비활성화되었습니다 설정에서 활성화해주세요")
            case .network:
                print("네트워크 오류")
            default:
                print("알 수 없는 오류")
            }
        }
    }
    
    private func moveCameraToCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        let currentPosition = MapPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        
        if let mapView = mapController?.getView("mapview") as? KakaoMap {
            mapView.moveCamera(CameraUpdate.make(target: currentPosition, zoomLevel: 17, mapView: mapView))
        }
    }
}
