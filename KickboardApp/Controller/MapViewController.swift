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
import CoreData

protocol MapViewControllerDelegate: AnyObject {
    func didTapStoprentalButton()
    func didTapStopReturnButton()
}

class MapViewController: UIViewController, MapControllerDelegate  {
    
    var container: NSPersistentContainer!
    
    weak var delegate: MapViewControllerDelegate?
    
    let searchMapView = SearchMapView()
    let locationManager = CLLocationManager()
    var selectedPoi: Poi?
    var mapView: MapView?
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    // var poiPositions: [MapPoint] = []
    var pois = [Kickboards]()
    var destinationPois = [MapPoint]()
    let alertImageView = AlertImageView()
    
    private var isMapInit = false
    // private var isRenting: Bool = false
    private var buttonState: MapButtonModel = .idle // 3개의 state 설정 필요하여 수정 - sh
    private let timerModel = TimerModel()
    
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
        mapContainer = mapView?.mapView // KMViewContainer 생성
        
        mapController = KMController(viewContainer: mapContainer!)
        mapController?.delegate = self
        mapController!.prepareEngine()
        DispatchQueue.main.async {
            self.mapController?.addView(mapviewInfo)
        }
        
        isMapInit = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setLocation()
        setupMyLocationButton()
        setupStopReturnButton()
        updateStopReturnButtonState()
        // generateRandomPoiPositions()
        searchButton()
        changeReturnButton()

        searchMapView.setupConstraints(in: view)
        searchMapView.delegate = self
        
        setupAlertImageViewConstraints()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
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
        // createPoi()
        updateMapView(latitude: 37.5491, longitude: 126.9137)
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
    
    
//    //   좌표모델.
//    private func generateRandomPoiPositions() {
//        let numberOfPois = 50
//        poiPositions = (0..<numberOfPois).map { _ in
//            let longitude = Double.random(in: 126.910...126.916)
//            let latitude = Double.random(in: 37.545...37.551)
//            return MapPoint(longitude: longitude, latitude: latitude)
//        }
//    }
    
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
//            selectedPoi = nil
            updateStopReturnButtonState()
        }
    }
    
    @objc func myLocationButtonTapped() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            moveCameraToCurrentLocation(location.coordinate)
        }
    }
    
    
    // 버튼 상태가 3개가 되어야 할 것 같아서 switch-case 문으로 수정 - sh
    @objc func stopReturnButtonTapped() {
        guard selectedPoi != nil else { return }
        // 윤대성 여기에 타임스탑,모달팝업 등의 동작을 넣으세요
        print("마커가 선택되었당")
        
        switch buttonState {
            // 반납버튼 누른 이후 처리
        case .renting:
            print("반납 버튼 클릭됨")
            // 알림을 먼저 띄우고 사용자의 응답에 따라 처리
            self.alertManager(title: "반납 요청", message: "반납하고 결제창으로 이동하시겠습니까?", confirmTitles: "예", cancelTitles: "아니오", confirmActions: { [weak self] _ in
                guard let self = self else { return }
                // 반납 처리
                self.mapView?.stopReturnButton.setTitle("대여하기", for: .normal)
                ReturnViewController.timer.stopTimer()
                self.searchMapView.textField.isEnabled.toggle()
                self.searchMapView.searchButton.isEnabled.toggle()
                self.destinationPois = []
                self.selectedPoi = nil
                self.buttonState = .idle
                if let searchText = self.searchMapView.textField.text {
                    print("주소 검색어: \(searchText)")
                    self.didSearchAddress(searchText)
                }
                if let tabBarController = self.tabBarController as? MainTabbarController {
                    tabBarController.selectedIndex = 0
                }
                
                // 반납 버튼이 클릭되면 마이페이지 레이블 텍스트 변경 - YJ
                delegate?.didTapStopReturnButton()
            })
            
            // 대여버튼 누른 이후 처리
        case .idle:
            print("대여 버튼 클릭됨")
            resetPoiLayer()
            mapView?.stopReturnButton.setTitle("목적지로 설정", for: .normal) // 버튼 제목 변경
            // 버튼이 클릭되면 마이페이지 레이블 텍스트 변경 - YJ
            mapView?.returnPointLabel.isHidden.toggle()
            delegate?.didTapStopReturnButton()
            if let selectedPoi = selectedPoi {
                destinationPois.append(selectedPoi.position)
            }
            buttonState = .designated
            
            mapView?.stopReturnButton.setTitle("반납하기", for: .normal) // 버튼 제목 변경
            ReturnViewController.timer.startTimer() // ReturnViewController의 타이머 시작
            
            // 대여 버튼이 클릭되면 마이페이지 레이블 텍스트 변경 - YJ
            delegate?.didTapStoprentalButton()
            
            // 목적지 설정 이후 처리
        case .designated:
            print("목적지로 설정 버튼 클릭됨")
            if destinationPois.count != 2 {
                self.alertManager(title: "경고", message: "주소창에서 목적지를 검색해서 설정해주세요!", confirmTitles: "확인")
                return
            }
            mapView?.returnPointLabel.isHidden.toggle()
            mapView?.stopReturnButton.setTitle("반납하기", for: .normal)
            createDestinationPoi(pois: destinationPois)
            updateCameraToFitAllPois()
            // showRideStartImage()
            searchMapView.textField.isEnabled.toggle()
            searchMapView.searchButton.isEnabled.toggle()
            showUseAlertImage()
            ReturnViewController.timer.startTimer()
            buttonState = .renting
        }
        deselectCurrentPoi()
    }
    
    @objc func searchButtonTapped() {
        guard let address = searchMapView.textField.text, !address.isEmpty else { return }
        print("search 버튼 눌림")
        searchMapView.delegate?.didSearchAddress(address)
    }
    
    private func searchButton() {
        searchMapView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    // 반납 버튼 설정
    private func changeReturnButton() {
        mapView?.stopReturnButton.setTitle("대여하기", for: .normal) // 기본 제목 설정
        mapView?.stopReturnButton.addTarget(self, action: #selector(stopReturnButtonTapped), for: .touchUpInside)
        updateStopReturnButtonState() // 얘 왜 쓰는거지
    }
    
    private func setLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupAlertImageViewConstraints() {
        view.addSubview(alertImageView)
        alertImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    private func showUseAlertImage() {
        alertImageView.showWithAnimation()
    }
}
    
    //MARK: - SearchMapView - sh
extension MapViewController: SearchMapViewDelegate {
    
    // delegate 필수함수 - sh
    func didSearchAddress(_ address: String) {
        // 주소검색 및 지도이동 처리 - sh
        searchAddress(address) { result in
            switch result {
            case .success(let documents):
                // 첫 번째 documents값에서 위도와 경도 가져오기
                if let document = documents.first,
                   let latitude = Double(document.latitude),
                   let longitude = Double(document.longitude) {
                    self.updateMapView(latitude: latitude, longitude: longitude)
                } else {
                    print("Address 데이터 오류")
                    self.alertManager(title: "주소 오류", message: "올바른 도로명/지번 주소를 입력해주세요.", confirmTitles: "확인")
                }
            case .failure(let error):
                self.alertManager(title: "검색 오류", message: "주소 검색 중 오류가 발생했습니다 - \(error)\n 다시 시도해주세요.", confirmTitles: "확인")
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
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
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
            return
        }
        
        let position = MapPoint(longitude: longitude, latitude: latitude)
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            print("맵뷰 로드 실패")
            return
        }
        
        mapView.moveCamera(CameraUpdate.make(target: position, zoomLevel: 15, mapView: mapView))
        if buttonState == .designated {
            if destinationPois.count == 1 {
                self.destinationPois.append(position)
            } else {
                resetPoiLayer()
                self.destinationPois[1] = position
            }
            createDestinationPoi(pois: [position])
        } else {
            resetPoiLayer()
            let pois = fetchPoisAround(latitude: latitude, longitude: longitude)
            print("POI 개수: \(pois.count)")
            createSearchedPoi(pois: pois)
        }
    }
    
    // 주변 반경 거리 계산 메서드
    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let latDiff = lat2 - lat1
        let lonDiff = lon1 - lon2
        return sqrt(latDiff * latDiff + lonDiff * lonDiff) * 111000
    }
    
    // 가로세로 1km 이내 poi 불러오기
    private func fetchPoisAround(latitude: Double, longitude: Double) -> [Kickboards] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Kickboards> = Kickboards.fetchRequest()

        let delta = 0.01

        let minLat = latitude - delta
        let maxLat = latitude + delta
        let minLon = longitude - delta
        let maxLon = longitude + delta

        fetchRequest.predicate = NSPredicate(format: "latitude >= %f AND latitude <= %f AND longitude >= %f AND longitude <= %f", minLat, maxLat, minLon, maxLon)

        do {
            let pois = try context.fetch(fetchRequest)
            print("Fetched POIs: \(pois.count)")
            return pois
        } catch {
            return []
        }
    }

    
    private func createSearchedPoi(pois: [Kickboards]) {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: "poiLayer") else {
            return
        }
        for poi in pois {
            let position = MapPoint(longitude: poi.longitude, latitude: poi.latitude)
            let options = PoiOptions(styleID: "blue", poiID: "poi_\(UUID().uuidString)")
            options.clickable = true
            if let poiItem = layer.addPoi(option: options, at: position) {
                poiItem.show()
                let _ = poiItem.addPoiTappedEventHandler(target: self) { [weak self] _ in
                    return { param in
                        self?.poiTapped(param)
                    }
                }
            } else {
                print("POI 찍기 실패")
            }
        }
    }

    // DestinationPois 관리 (출발지 - 도착지)
    private func createDestinationPoi(pois: [MapPoint]) {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: "poiLayer") else {
            return
        }
        for (index, poi) in pois.enumerated() {
            let styleID = index == 0 ? "leave" : "arrive"
            let options = PoiOptions(styleID: styleID, poiID: "poi_\(UUID().uuidString)")
            options.clickable = true
            if let poiItem = layer.addPoi(option: options, at: poi) {
                poiItem.show()
                let _ = poiItem.addPoiTappedEventHandler(target: self) { [weak self] _ in
                    return { param in
                        self?.poiTapped(param)
                    }
                }
            } else {
                print("POI 찍기 실패")
            }
        }
    }
    
    // 핀 두개를 한 화면에 다 보이게 하는 메서드
    private func updateCameraToFitAllPois() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }

        let points = destinationPois
        if points.count < 2 { return }

        let bounds = AreaRect(points: points)
        let cameraUpdate = CameraUpdate.make(area: bounds)
        mapView.moveCamera(cameraUpdate)
    }
}



//MARK: - POI
extension MapViewController: KakaoMapEventDelegate {
    func createPoiStyle() { // 보이는 스타일 정의
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        let image = UIImage(named: "DefaultScooterPoi")
        let icon = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
        let poiStyle = PoiStyle(styleID: "blue", styles: [perLevelStyle])
        labelManager.addPoiStyle(poiStyle)
        
        // 클릭된 상태의 스타일 추가
        let clickedImage = UIImage(named: "TouchedScooterPoi") // 클릭 시 변경될 이미지
        let clickedIcon = PoiIconStyle(symbol: clickedImage, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let clickedPerLevelStyle = PerLevelPoiStyle(iconStyle: clickedIcon, level: 0)
        let clickedPoiStyle = PoiStyle(styleID: "clicked", styles: [clickedPerLevelStyle])
        labelManager.addPoiStyle(clickedPoiStyle)
        
        // 출발지 스타일
        let leaveImage = UIImage(named: "LeaveScooterPoi")
        let leaveIcon = PoiIconStyle(symbol: leaveImage, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let leavePerLevelStyle = PerLevelPoiStyle(iconStyle: leaveIcon, level: 0)
        let leavePoiStyle = PoiStyle(styleID: "leave", styles: [leavePerLevelStyle])
        labelManager.addPoiStyle(leavePoiStyle)
        
        // 목적지 스타일
        let arriveImage = UIImage(named: "ArriveScooterPoi")
        let arriveIcon = PoiIconStyle(symbol: arriveImage, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let arrivePerLevelStyle = PerLevelPoiStyle(iconStyle: arriveIcon, level: 0)
        let arrivePoiStyle = PoiStyle(styleID: "arrive", styles: [arrivePerLevelStyle])
        labelManager.addPoiStyle(arrivePoiStyle)
    }
    
    func createLabelLayer() { // 레이어생성
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let labelManager = mapView.getLabelManager()
        let layer = LabelLayerOptions(layerID: "poiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = labelManager.addLabelLayer(option: layer)
    }
    
//    func createPoi() {
//        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
//            return
//        }
//        let labelManager = mapView.getLabelManager()
//        guard let layer = labelManager.getLabelLayer(layerID: "poiLayer") else {
//            return
//        }
//        for (index, position) in poiPositions.enumerated() {
//            let options = PoiOptions(styleID: "blue", poiID: "bluePoi_\(index)")
//            options.clickable = true
//            if let poi = layer.addPoi(option: options, at: position) {
//                poi.show()
//                // POI 클릭 이벤트 핸들러 추가
//                let _ = poi.addPoiTappedEventHandler(target: self) { [weak self] _ in
//                    return { param in
//                        self?.poiTapped(param)
//                    }
//                }
//            }
//        }
//    }
    
    func poiTapped(_ param: PoiInteractionEventParam) {
        guard let poi = param.poiItem as? Poi else { return }
        
        // 이전에 선택된 POI가 있다면 스타일 변경
        deselectCurrentPoi()
        
        // 새로운 POI 선택
        selectedPoi = poi
        poi.changeStyle(styleID: "clicked")
        
        // Stop/Return 버튼 상태 업데이트
        updateStopReturnButtonState()
        
        // poi 카메라 이동 - sh
        moveCameraToPoi(poi)
        
//        // 현재 로그인한 유저의 ID 가져오기
//            guard let currentUserIdString = UserDefaults.standard.string(forKey: "currentUserId"),
//                  let currentUserId = UUID(uuidString: currentUserIdString) else {
//                print("로그인한 유저 ID를 가져올 수 없습니다.")
//                return
//            }
            
        // 현재 로그인한 유저의 ID 가져오기
        guard let currentUserIdString = UserDefaults.standard.string(forKey: "currentUserId"),
              let currentUserId = UUID(uuidString: currentUserIdString) else {
            print("로그인한 유저 ID를 가져올 수 없습니다.")
            return
        }
        
        // 정보 표시
        let alert = UIAlertController(title: "위치 정보", message: "\n위치: \(poi.position)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            // 알림창을 닫아도 POI는 선택된 상태로 유지
        })
        present(alert, animated: true, completion: nil)
    }
    
    // poi layer 초기화하는 메서드 - sh
    func resetPoiLayer() {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        labelManager.removeLabelLayer(layerID: "poiLayer")
        
        createLabelLayer()
    }
    
    // poi로 카메라 이동하는 메서드 - sh
    private func moveCameraToPoi(_ poi: Poi) {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let position = poi.position
        let cameraUpdate = CameraUpdate.make(target: position, zoomLevel: 15, mapView: mapView)
        mapView.moveCamera(cameraUpdate)
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
