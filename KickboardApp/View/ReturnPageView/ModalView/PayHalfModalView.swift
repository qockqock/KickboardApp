//
//  ModalView.swift
//  KickboardApp
//
//  Created by 머성이 on 7/23/24.
//

import UIKit
import SnapKit
import SwiftUI

class PayHalfModalView: UIView {
    // MARK: - 결제수단 하프모달 Value 관련 - DS
    // 결제수단 배열
    private let paymentMethods = ["킥키킥 페이머니", "신용/체크카드", "토스페이", "카카오페이"]
    weak var delegate: PayHalfModalViewDelegate?
    
    // 현재 선택된 라디오 버튼을 저장
    private var selectedRadioButton: UIButton?
    
    // 내용들을 스택뷰로 묶어서 관리하기 편하게 함
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성 메서드
    private func configureUI() {
        // "결제수단" 레이블 추가
        let paymentMethodLabel = UILabel()
        paymentMethodLabel.text = "결제수단"
        paymentMethodLabel.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(paymentMethodLabel)
        
        // 스택뷰 추가
        addSubview(stackView)
        
        // "결제수단" 레이아웃 설정
        paymentMethodLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(-40)
            $0.leading.equalToSuperview().offset(16)
        }
        
        // 스택뷰 레이아웃 설정
        stackView.snp.makeConstraints {
            $0.top.equalTo(paymentMethodLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.lessThanOrEqualTo(self).offset(-32)
        }
        
        // 결제수단 배열을 순회하며 각 결제수단 뷰 생성
        for method in paymentMethods {
            let containerView = createPaymentMethodView(method: method)
            stackView.addArrangedSubview(containerView)
        }
        
        // 추가적인 혜택 설명 레이블 추가
        let benefitsLabel = UILabel()
        benefitsLabel.text = """
            • 킥키킥 페이로 결제하면 10% 적립된다구~ (~7/29)
            • 카카오페이, 토스로 결제하면 5% 페이백!?
            """

        benefitsLabel.font = UIFont.systemFont(ofSize: 14)
        benefitsLabel.textColor = .gray
        benefitsLabel.numberOfLines = 0
        stackView.addArrangedSubview(benefitsLabel)
    }
    
    // MARK: - 결제수단 뷰 생성 메서드
    private func createPaymentMethodView(method: String) -> UIView {
        let containerView = UIView()
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = 8
        hStackView.alignment = .center
        
        let radioButton = UIButton(type: .custom)
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        radioButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        radioButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        hStackView.addArrangedSubview(radioButton)
        
        let imageView = UIImageView()
        switch method {
        case "토스페이":
            imageView.image = UIImage(named: "tossSymbol")
        case "카카오페이":
            imageView.image = UIImage(named: "kakaoPaySymbol")
        default:
            imageView.image = nil
        }
        imageView.contentMode = .scaleAspectFit
        hStackView.addArrangedSubview(imageView)
        
        let label = UILabel()
        label.text = method
        label.font = UIFont.systemFont(ofSize: 18)
        hStackView.addArrangedSubview(label)
        
        containerView.addSubview(hStackView)
        
        // 레이아웃 설정
        hStackView.snp.makeConstraints {
            $0.edges.equalTo(containerView)
        }
        
        radioButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        // 이미지 심볼 없을 때 레이블 레이아웃 당기기
        if imageView.image != nil {
            imageView.snp.makeConstraints {
                $0.width.height.equalTo(24)
            }
        } else {
            imageView.snp.makeConstraints {
                $0.width.equalTo(0)
            }
        }
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        return containerView
    }

    // 라디오 버튼 탭 시 호출되는 메서드
    @objc private func radioButtonTapped(_ sender: UIButton) {
        selectedRadioButton?.isSelected = false
        sender.isSelected = true
        selectedRadioButton = sender
        
        if let index = stackView.arrangedSubviews.firstIndex(where: { ($0.subviews.first?.subviews.first as? UIButton) == sender }) {
            let selectedMethod = paymentMethods[index]
            delegate?.paymentMethodSelected(selectedMethod)
        }
    }
}


//struct PreView: PreviewProvider {
//  static var previews: some View {
//    PayHalfModalViewController().toPreview()
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
