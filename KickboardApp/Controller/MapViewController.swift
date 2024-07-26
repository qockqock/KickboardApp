//
//  MapViewController.swift
//  KickboardApp
//
//  Created by 머성이 on 7/22/24.
//

import UIKit
import SnapKit
import KakaoMapsSDK
import Alamofire

protocol MapViewControllerDelegate: AnyObject {
    func didTapStopReturnButton()
}

class MapViewController: UIViewController, MapControllerDelegate, SearchMapViewDelegate {
    
    weak var delegate: MapViewControllerDelegate?
    
    let searchMapView = SearchMapView()
    
    private lazy var mapView: KMViewContainer = {
        let view = KMViewContainer()
        return view
    }()
    
    // searchMapView로 대체했습니다 - sh
//    private var mapSearchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "위치 검색"
//        searchBar.backgroundColor = .white
//        searchBar.layer.cornerRadius = 10
//        searchBar.clipsToBounds = true
//        return searchBar
//    }()
    
    private lazy var stopReturnButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitle("반납하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(stopReturnButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func addViews() {
        //여기에서 그릴 View(KakaoMap, Roadview)들을 추가한다.
        let defaultPosition: MapPoint = MapPoint(longitude: 126.9137, latitude: 37.5491)
        //지도(KakaoMap)를 그리기 위한 viewInfo를 생성
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 17)
        
        mapContainer = mapView
        guard mapContainer != nil else {
            print("맵 생성 실패")
            return
        }
        
        //KMController 생성.
        mapController = KMController(viewContainer: mapContainer!)
        mapController!.delegate = self
        
        mapController?.prepareEngine() //엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다.
        //KakaoMap 추가.
        DispatchQueue.main.async {
            self.mapController?.addView(mapviewInfo)
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _observerAdded = false
        _auth = false
        _appear = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        _observerAdded = false
        _auth = false
        _appear = false
        super.init(coder: aDecoder)
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hj test
        mapSetupUI()
        addViews()
        
        searchMapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if mapController == nil {
            addViews()
        }
        mapController?.activateEngine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()  //렌더링 중지.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()
        //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
        
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
            break
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
            break
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
            break
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
            break
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break
        default:
            break
        }
    }
    
    // MARK: - auto layout
    private func mapSetupUI() {
        view.backgroundColor = .white
        
        [mapView, searchMapView, stopReturnButton].forEach {
            self.view.addSubview($0)
        }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchMapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        stopReturnButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(180)
            $0.height.equalTo(50)
        }
        
    }
    
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        print("OK") //추가 성공. 성공시 추가적으로 수행할 작업을 진행한다.
        _auth = true
        createPoiStyle()
        createLabelLayer()
        
        // 예시 위치에 POI 생성
        let position = MapPoint(longitude: 126.9137, latitude: 37.5491)
        createPoi(at: position)
        
        if let mapView = mapController?.getView("mapview") as? KakaoMap {
            mapView.moveCamera(CameraUpdate.make(target: position, zoomLevel: 15, mapView: mapView))
            }
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
        
    }
    
    func viewWillDestroyed(_ view: ViewBase) {
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = true
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = false
    }
    
    // MARK: - stopReturnButton 버튼 클릭 - YJ
    @objc private func stopReturnButtonTapped() {
        delegate?.didTapStopReturnButton()
        // 버튼이 클릭되면 레이블의 텍스트를 변경
    }
    
    @objc func willResignActive(){
        mapController?.pauseEngine()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }
    
    @objc func didBecomeActive(){
        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
    func mapControllerDidChangeZoomLevel(_ mapController: KakaoMapsSDK.KMController, zoomLevel: Double) {
        print("Zoom level changed to: \(zoomLevel)")
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
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear: Bool = false
    
    
    //MARK: - POI
    
    func createPoiStyle() { // 보이는 스타일 정의
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        
        guard let image = UIImage(named: "pin_blue.png") else {
            return
        }
        
        let icon = PoiIconStyle(symbol: image, anchorPoint: CGPoint(x: 0.5, y: 1.0))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: icon, level: 0)
        let poiStyle = PoiStyle(styleID: "blue", styles: [perLevelStyle])
        labelManager.addPoiStyle(poiStyle)
    }
    
    func createLabelLayer() { // 레이어생성
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else { return }
        let labelManager = mapView.getLabelManager()
        let layer = LabelLayerOptions(layerID: "poiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
        let _ = labelManager.addLabelLayer(option: layer)
    }
    
    func createPoi(at position: MapPoint) {
        guard let mapView = mapController?.getView("mapview") as? KakaoMap else {
            return
        }
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: "poiLayer") else {
            return
        }
        
        let options = PoiOptions(styleID: "blue", poiID: "bluePoi")
        
        if let poi = layer.addPoi(option: options, at: position) {
            poi.show()
        }
    }
    
    // 좌표설정
//    var poiPositions: [MapPoint] = [
//        MapPoint(longitude: 126.9137, latitude: 37.5491),
//        MapPoint(longitude: 126.9137, latitude: 37.5491),
//        MapPoint(longitude: 126.9137, latitude: 37.5491),
//        MapPoint(longitude: 126.9137, latitude: 37.5491),
//    
//    ]
    
    //MARK: SearchMapView - sh


    // delegate 필수함수 - sh
    func didSearchAddress(_ documents: String) {
        guard _auth else {
            print("인증상태 없음")
            return
        }

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
        mapView.moveCamera(CameraUpdate.make(target: position, zoomLevel: 15, mapView: mapView))
        createPoi(at: position)
    }
}


