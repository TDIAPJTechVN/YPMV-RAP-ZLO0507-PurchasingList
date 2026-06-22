@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - Purchasing List'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZI_LO05_07_PList
  as select from I_PurchaseOrderItemAPI01 as Pitem
  association [1..1] to I_PurchaseOrderAPI01           as _PurchaseOrder on  $projection.PurchaseOrder = _PurchaseOrder.PurchaseOrder

  association [1]    to I_PurchaseRequisitionAPI01     as _PR            on  _PR.PurchaseRequisition = Pitem.PurchaseRequisition

  association [0..1] to I_ProductGroupText_2           as _ProdGroupText on  _ProdGroupText.ProductGroup = Pitem.MaterialGroup
                                                                         and _ProdGroupText.Language     = 'E'

  association [0..1] to I_ProductText                  as _ProdTextEN    on  _ProdTextEN.Product  = Pitem.Material
                                                                         and _ProdTextEN.Language = 'E'

  association [0..1] to I_ProductText                  as _ProdTextVI    on  _ProdTextVI.Product  = Pitem.Material
                                                                         and _ProdTextVI.Language = '쁩'

  association [1]    to ZI_LO05_07_ProductGrp          as _Product       on  _Product.Product = Pitem.Material

  association [0..1] to I_PurchaseRequisitionItemAPI01 as _PRItem        on  _PRItem.PurchaseRequisition     = Pitem.PurchaseRequisition
                                                                         and _PRItem.PurchaseRequisitionItem = Pitem.PurchaseRequisitionItem

  association [0..1] to ZI_LO05_07_MatDocAgg           as _MatDoc        on  _MatDoc.PurchaseOrder     = Pitem.PurchaseOrder
                                                                         and _MatDoc.PurchaseOrderItem = Pitem.PurchaseOrderItem

//  association [1]    to ZI_LO05_07_Invoice             as _Invoice       on  _Invoice.PurchaseOrder     = Pitem.PurchaseOrder
//                                                                         and _Invoice.PurchaseOrderItem = Pitem.PurchaseOrderItem

  association [1]    to ZI_LO05_07_PO                  as _POCreator     on  _POCreator.PurchaseOrder = Pitem.PurchaseOrder

  association [1]    to ZI_LO05_07_IB_Delivery         as _IBdel         on  _IBdel.PurchaseOrder     = Pitem.PurchaseOrder
                                                                         and _IBdel.PurchaseOrderItem = Pitem.PurchaseOrderItem

  association [1]    to ZI_LO05_07_PurOrdAccount       as _PurOrdAccount on  _PurOrdAccount.PurchaseOrder     = Pitem.PurchaseOrder
                                                                         and _PurOrdAccount.PurchaseOrderItem = Pitem.PurchaseOrderItem

  association [1]    to I_PurOrdScheduleLineAPI01      as _SCHEDULE      on  _SCHEDULE.PurchaseOrder     = Pitem.PurchaseOrder
                                                                         and _SCHEDULE.PurchaseOrderItem = Pitem.PurchaseOrderItem
  association [0..1] to I_AcctAssignmentCategoryText   as _CategoryText  on  _CategoryText.AccountAssignmentCategory = Pitem.AccountAssignmentCategory
                                                                         and _CategoryText.Language                  = '쁩'

  association [1]    to ZI_LO05_07_GLAccount           as _GLAccount     on  _GLAccount.PurchaseOrder     = Pitem.PurchaseOrder
                                                                         and _GLAccount.PurchaseOrderItem = Pitem.PurchaseOrderItem
  association [0..1] to ZI_LO05_07_DeliveredQty        as _DeliveredQty  on  _DeliveredQty.PurchaseOrder     = Pitem.PurchaseOrder
                                                                         and _DeliveredQty.PurchaseOrderItem = Pitem.PurchaseOrderItem
{

  key     Pitem.PurchaseOrder                        as PurchaseOrder,
  key     Pitem.PurchaseOrderItem                    as PurchaseOrderItem,
//  key     _Invoice.SupplierInvoice                   as SupplierInvoice,
//  key     _Invoice.SupplierInvoiceItem               as SupplierInvoiceItem,
          _PR.PurchaseRequisitionType                as ShopCode,
          Pitem.PurchasingDocumentDeletionCode       as PurchasingDocumentDeletionCode,
          _PurchaseOrder .PurchaseOrderDate          as PurchaseOrderDate,
          Pitem.MaterialGroup                        as MaterialGroup,
          case
            when _ProdGroupText.ProductGroupText <> '' then _ProdGroupText.ProductGroupText
            else _ProdGroupText.ProductGroupName
          end                                        as MaterialGroupDescription,
          Pitem.PurchaseRequisition                  as PurchaseRequisition,
          Pitem.PurchaseRequisitionItem              as PurchaseRequisitionItem,
          _PurchaseOrder.Supplier                    as Supplier,
          //      _Slier.SupplierName               as SupplierName,
          _ProdTextEN.ProductName                    as ProductName,
          _ProdTextVI.ProductName                    as ProductName_VI,
          //      _ProdLongText.ProductLongText        as ProductLongText,
          Pitem.Material                             as ProductCode,

          Pitem.PurchaseOrderQuantityUnit            as PurchaseOrderQuantityUnit,
          @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
          Pitem.OrderQuantity                        as OrderQuantity,

          Pitem.DocumentCurrency                     as DocumentCurrency,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          Pitem.NetPriceAmount                       as NetPriceAmount,
          @Semantics.amount.currencyCode: 'DocumentCurrency'
          Pitem.NetAmount                            as NetAmount,

          _PurchaseOrder.SupplierRespSalesPersonName as SupplierRespSalesPersonName,
          _POCreator.PersonFullName                  as PersonFullName,
          _POCreator.SupplierName                    as SupplierName,

          _PRItem.PurReqCreationDate                 as RequestedDeliveryDate,

          _MatDoc.PostingDate                        as ActualDate,
          _DeliveredQty.MaterialBaseUnit             as MaterialBaseUnit,
          @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
          _DeliveredQty.DeliveredQty                 as DeliveredQty,
          //      _Invoice.SupplierInvoice                   as SupplierInvoice,
          //      _Invoice.SupplierInvoiceItem               as SupplierInvoiceItem,
//          _Invoice.PostingDate                       as InvoiceDate,
//
//          _Invoice.DocumentCurrency                  as DocumentCurrency_INV,
//          @Semantics.amount.currencyCode: 'DocumentCurrency_INV'
//          case
//            when _Invoice.DebitCreditCode = 'S'
//              then _Invoice.SupplierInvoiceItemAmount
//            else - _Invoice.SupplierInvoiceItemAmount
//          end                                        as SupplierInvoiceItemAmount,
//
//          @Semantics.amount.currencyCode: 'DocumentCurrency_INV'
//          case
//            when _Invoice.DebitCreditCode = 'S'
//              then _Invoice.SuplrInvcItmUnplndDelivCost
//            else - _Invoice.SuplrInvcItmUnplndDelivCost
//          end                                        as SuplrInvcItmUnplndDelivCost,

//          @Semantics.amount.currencyCode: 'DocumentCurrency_INV'
//          case
//            when _Invoice.DebitCreditCode = 'S'
//              then _Invoice.SuplrInvcItmUnplndDelivCost
//                   + _Invoice.SupplierInvoiceItemAmount
//            else - ( _Invoice.SuplrInvcItmUnplndDelivCost
//                     + _Invoice.SupplierInvoiceItemAmount )
//          end                                        as InvoiceAmount,

//          _Invoice.DebitCreditCode                   as DebitCreditCode,

          _IBdel.BillOfLading                        as BillOfLading,
          _IBdel.TrPlanDate                          as TrPlanDate,
          _IBdel.DeliveryDate                        as DeliveryDate,
          ''                                         as blankmode,
          ''                                         as HScode,

          _PurOrdAccount.Project                     as Project,
          _PurOrdAccount.ProjectDescription          as ProjectDescription,

          //update v3
          _SCHEDULE.ScheduleLineDeliveryDate         as SchedLineStscDeliveryDate,
          _PurchaseOrder.PaymentTerms                as PaymentTerms,
          _POCreator.PaymentTermsName                as PaymentTermsName,
          Pitem.AccountAssignmentCategory            as AccountAssignmentCategory,
          _CategoryText.AcctAssignmentCategoryName   as AcctAssignmentCategoryName,

//          _Invoice.InvoiceYear                       as InvoiceYear,
          _GLAccount.GLAccount                       as GLAccount,
          _GLAccount.GLAccountLongName               as GLAccountLongName,
          _GLAccount.CostCenter,
          _GLAccount.CostCenterDescription,
          _GLAccount.FunctionalArea,
          _GLAccount.FunctionalAreaName,
//          _Invoice.PurchaseOrderQuantityUnit         as PurchaseOrderQuantityUnit_EINV,
//          @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit_EINV'
//          _Invoice.QuantityInPurchaseOrderUnit,

          //update v4
          _Product.ExternalProductGroup,
          _Product.ExternalProductGroupName          as ExternalProductGroupName,
          
          //update v5
          _PurchaseOrder.CorrespncInternalReference as OurREF,
          _PurchaseOrder.CorrespncExternalReference as YourREF,
          
          //update v6
          Pitem.GoodsReceiptIsNonValuated 
          
}

where
  Pitem.PurchasingDocumentDeletionCode is initial
