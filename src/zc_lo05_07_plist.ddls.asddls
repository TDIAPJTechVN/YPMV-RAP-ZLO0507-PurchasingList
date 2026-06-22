@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: C - PO List'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_LO05_07_PLIST
  as projection on ZI_LO05_07_PList
{
  key           PurchaseOrder,
  key           PurchaseOrderItem,
//  key           SupplierInvoice,
//  key           SupplierInvoiceItem,
                ShopCode,
                SchedLineStscDeliveryDate,
                PurchasingDocumentDeletionCode,
                PurchaseOrderDate,
                MaterialGroup,
                MaterialGroupDescription,
                PurchaseRequisition,
                PurchaseRequisitionItem,
                Supplier,
                SupplierName,
                ProductName,
                ProductName_VI,
                ProductCode,
                PurchaseOrderQuantityUnit,
                @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
                OrderQuantity,
                DocumentCurrency,
                @Semantics.amount.currencyCode: 'DocumentCurrency'
                NetPriceAmount,
                @Semantics.amount.currencyCode: 'DocumentCurrency'
                NetAmount,
                SupplierRespSalesPersonName,
                PersonFullName,
                RequestedDeliveryDate,
                ActualDate,

//                InvoiceDate,
//                DocumentCurrency_INV,
//                @Semantics.amount.currencyCode: 'DocumentCurrency_INV'
//                SupplierInvoiceItemAmount,
//                @Semantics.amount.currencyCode: 'DocumentCurrency_INV'
//                SuplrInvcItmUnplndDelivCost,
//                @Semantics.amount.currencyCode: 'DocumentCurrency_INV'
//                InvoiceAmount,
//                DebitCreditCode,
                BillOfLading,
                TrPlanDate,
                DeliveryDate,
                blankmode,
                HScode,
                Project,
                ProjectDescription,
                // update v1.3
                PaymentTerms,
                PaymentTermsName,
                AccountAssignmentCategory,
                AcctAssignmentCategoryName,
//                InvoiceYear,
                GLAccount,
                GLAccountLongName,
                CostCenter,
                CostCenterDescription,
                FunctionalArea,
                FunctionalAreaName,
                MaterialBaseUnit,
                @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
                DeliveredQty,
//                PurchaseOrderQuantityUnit_EINV,
//                @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit_EINV'
//                QuantityInPurchaseOrderUnit,
                ExternalProductGroup,
                ExternalProductGroupName,
                OurREF,
                YourREF,
                GoodsReceiptIsNonValuated ,

                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
                @EndUserText.label: 'Still to be delivered (qty)'
  virtual       Stilldelivered_qty   : abap.char(70),

                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
                @EndUserText.label: 'Still to be delivered (value)'
                @Semantics.amount.currencyCode: 'DocumentCurrency'
  virtual       Stilldelivered_value : abap.curr( 13, 2 ),

                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
                @EndUserText.label: 'Still to be invoiced (qty)'
  virtual       StillInvoice_qty     : abap.char(70),

                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
                @EndUserText.label: 'Still to be invoiced (value)'
                @Semantics.amount.currencyCode: 'DocumentCurrency'
  virtual       StillInvoice_value   : abap.curr( 13, 2 ),

                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
                @EndUserText.label: 'Long Text'
  virtual       ZLONGTEXT            : abap.char(70),

                //update v0.6 : change data for supplier invoice 
                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
  virtual       SupplierInvoice   : abap.string,
  
                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
  virtual       SupplierInvoiceItem   : abap.string,  
  
                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
  virtual       InvoiceDate      : abap.string,  
  
                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
  virtual       InvoiceYear      : abap.char(70),     
        
                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
  virtual       DocumentCurrency_INV      : waers,   
  
                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
                @Semantics.amount.currencyCode: 'DocumentCurrency_INV'
  virtual       InvoiceAmount      : abap.curr( 13, 2 ),    
  
                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
  virtual       PurchaseOrderQuantityUnit_EINV      : bstme,    
    
                @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_LO05_07_PLIST_VIR'
                @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit_EINV'
  virtual       QuantityInPurchaseOrderUnit      : menge_d      
  
}
