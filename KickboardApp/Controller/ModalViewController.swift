//
//  ModalViewController.swift
//  KickboardApp
//
//  Created by 머성이 on 7/23/24.
//

import UIKit
import SnapKit
import SwiftUI

// 결제 수단 선택 델리게이트 프로토콜 정의
protocol PayHalfModalViewDelegate: AnyObject {
    func paymentMethodSelected(_ method: String)
}

class PayHalfModalViewController: UIViewController, PayHalfModalViewDelegate {

    private let payHalfModalView = PayHalfModalView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        payHalfModalView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        payHalfModalView.delegate = nil
    }

    private func configureUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(payHalfModalView)
        
        payHalfModalView.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.centerY.equalTo(view)
            $0.leading.equalTo(view).offset(16)
            $0.trailing.equalTo(view).offset(-16)
        }

        // 모달 바깥을 탭하면 모달을 닫기 위한 제스처 추가
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }

    // 결제 수단 선택 시 호출되는 메서드
    func paymentMethodSelected(_ method: String) {
        // 선택된 결제 수단 처리
        print("Selected payment method: \(method)")
    }
}

class PromotionHalfModalViewController: UIViewController {
    
    private let promotionHalfModalView = PromotionHalfModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        promotionHalfModalView.getCouponsButton.addTarget(self, action: #selector(promotionButtonTapped), for: .touchUpInside)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(promotionHalfModalView)
        
        promotionHalfModalView.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.leading.equalTo(view).offset(16)
            $0.trailing.equalTo(view).offset(-16)
            $0.height.equalTo(208) // 원하는 높이 값으로 설정합니다.
        }

        // 모달 바깥을 탭하면 모달을 닫기 위한 제스처 추가
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // 쿠폰사용 버튼액션
    @objc
    private func promotionButtonTapped() {
        
    }
    
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
}
//
//struct PreView: PreviewProvider {
//  static var previews: some View {
//      PromotionHalfModalViewController().toPreview()
//  }
//}
//#if DEBUG
//extension UIViewController {
//  private struct Preview: UIViewControllerRepresentable {
//      let viewController: UIViewController
//      func makeUIViewController(context: Context) -> UIViewController {
//        return viewController
//      }
//      func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//      }
//    }
//    func toPreview() -> some View {
//      Preview(viewController: self)
//    }
//}
//#endif
