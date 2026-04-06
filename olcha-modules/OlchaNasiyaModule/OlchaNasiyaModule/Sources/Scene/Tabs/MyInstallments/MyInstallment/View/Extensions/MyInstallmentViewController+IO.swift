//
//  MyInstallmentViewController+IO.swift
//  OlchaNasiyaModule
//
//  Created by Elbek Khasanov on 18/05/23.
//
import OlchaUI
import Foundation
extension MyInstallmentViewController {
    public struct Output {
        public var currentState: SegmentState = .graph
        public var shouldPay: Bool = false
        
        public init() {}
    }
    
    public struct Input {
        public var installment: InstallmentModel? {
            didSet {
                setupDatas()
            }
        }
        
        public var monthlyPayments: [InstallmentGraphMonthModel] = []
        public var details: [InstallmentGraphDetailModel] = []
        public var graphHeader: InstallmentGraphModel?
        
        public var skeleton = Skeleton(count: 7)
        
        public init() {}
        
        private mutating func createHeader() {
            graphHeader = InstallmentGraphModel(id: installment?.id,
                                                date: installment?.created_at?.formated_date,
                                                paid: installment?.getPaid(),
                                                need_pay: installment?.getRemainder(),
                                                total_pay: installment?.getTotalPayment())
        }
        
        public mutating func resetDatas() {
            monthlyPayments = []
            details = []
        }
        
        private mutating func setupDatas() {
            monthlyPayments = installment?.graphs ?? []
            details = installment?.getDetails() ?? []
            createHeader()
        }
    }
}
