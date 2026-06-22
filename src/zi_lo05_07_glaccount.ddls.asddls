@AbapCatalog.sqlViewName: 'ZI_LO05_07_GL'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - Get data GL account'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_LO05_07_GLAccount
  as select from    I_PurOrdAccountAssignmentAPI01 as POAssignment
    left outer join I_GLAccountTextRawData         as GLText     on  GLText.GLAccount       = POAssignment.GLAccount
                                                                 and GLText.Language        = '쁩'
                                                                 and GLText.ChartOfAccounts = 'YCOA'
    left outer join I_CostCenterText               as CENTERTEXT on  CENTERTEXT.CostCenter = POAssignment.CostCenter
                                                                 and CENTERTEXT.Language   = 'E'
    left outer join I_FunctionalAreaText           as AreaText   on  AreaText.FunctionalArea = POAssignment.FunctionalArea
                                                                 and AreaText.Language       = 'E'
{
  key    POAssignment.PurchaseOrder,
  key    POAssignment.PurchaseOrderItem,
         POAssignment.GLAccount,
         GLText.GLAccountLongName,
         POAssignment.CostCenter,
         CENTERTEXT.CostCenterDescription,
         POAssignment.FunctionalArea,
         AreaText.FunctionalAreaName

}
