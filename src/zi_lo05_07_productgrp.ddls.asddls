@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LO05_07: I - Product Grp'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_LO05_07_ProductGrp
  as select from    I_Product        as Prd
    left outer join I_ExtProdGrpText as ProdGrpText on  Prd.ExternalProductGroup = ProdGrpText.ExternalProductGroup
                                                    and ProdGrpText.Language     = 'E'
{
  key Prd.Product as Product,
      Prd.ExternalProductGroup,
      ProdGrpText.ExternalProductGroupName
}
