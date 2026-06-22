CLASS zcl_lo05_07_plist_vir DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LO05_07_PLIST_VIR IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF iv_entity NS 'ZC_LO05_07'.
      RETURN.
    ENDIF.
    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
      CASE <fs_calc_element>.
        WHEN 'ZLONGTEXT'.
          INSERT `PRODUCTCODE` INTO TABLE et_requested_orig_elements.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_original_data TYPE TABLE OF zc_lo05_07_Plist.
    lt_original_data = CORRESPONDING #( it_original_data ).

    SELECT ltext~product, ltext~productlongtext FROM
       i_productbasictexttp_2 AS ltext
       INNER JOIN @lt_original_data AS mat ##ITAB_DB_SELECT  ##ITAB_KEY_IN_SELECT
               ON mat~ProductCode = ltext~product
        ORDER BY mat~ProductCode
       INTO TABLE @DATA(lt_longtext).

    "update Supplier Invoice
    SELECT DISTINCT
           dt~PurchaseOrder,
           dt~PurchaseOrderitem,
           dt~supplierinvoice,
           dt~supplierinvoiceitem,
           dt~PostingDate,
           dt~invoiceyear
    FROM ZI_LO05_07_Invoice AS dt
    INNER JOIN @lt_original_data AS chk ##ITAB_DB_SELECT  ##ITAB_KEY_IN_SELECT
               ON chk~PurchaseOrder = dt~PurchaseOrder
              AND chk~PurchaseOrderitem = dt~PurchaseOrderItem
       INNER JOIN I_PurchaseOrderHistoryAPI01 AS ref
               ON ref~PurchaseOrder = dt~PurchaseOrder
              AND ref~PurchaseOrderitem = dt~PurchaseOrderItem
              AND ref~PurchasingHistoryCategory IN ( 'Q' , 'R' )
       WHERE dt~supplierinvoice IS NOT INITIAL
        ORDER BY dt~PurchaseOrder, dt~PurchaseOrderitem
       INTO TABLE @DATA(lt_supplierinv).
    SORT lt_supplierinv BY PurchaseOrder PurchaseOrderitem supplierinvoice supplierinvoiceitem .

*    SELECT
*      dt~PurchaseOrder,
*      dt~PurchaseOrderitem,
*      sapi~DocumentCurrency,
*      SUM(  InvoiceGrossAmount  ) AS amount
*    FROM @lt_supplierinv AS dt
*    INNER JOIN I_SupplierInvoiceAPI01 AS sapi
*            ON dt~supplierinvoice = sapi~supplierinvoice
*    GROUP BY dt~PurchaseOrder, dt~PurchaseOrderitem, sapi~DocumentCurrency
*    INTO TABLE @DATA(lt_samount).

    SELECT
      dt~PurchaseOrder,
      dt~PurchaseOrderitem,
      dt~supplierinvoice,
      sapi~DocumentCurrency,
      sapi~SupplierInvoiceItemAmount as amount,
      sapi~SUPLRINVCITMUNPLNDDELIVCOST ,
      tax~taxcode,
      tax~ConditionRateRatio,
      tax~ConditionRateRatiounit
    FROM @lt_supplierinv AS dt
    INNER JOIN I_SuplrInvcItemPurOrdRefAPI01  AS sapi
            ON dt~supplierinvoice = sapi~supplierinvoice
            and dt~supplierinvoiceitem = sapi~SupplierInvoiceItem
    left join I_taxcoderate as tax
                     on tax~taxcode = sapi~taxcode
    order BY dt~PurchaseOrder, dt~PurchaseOrderitem
    INTO TABLE @DATA(lt_samount).


    SELECT
      sapi~PurchaseOrder,
      sapi~PurchaseOrderitem,
      sapi~PurchaseOrderQuantityUnit,
      SUM( quantityinpurchaseorderunit  ) AS squantity
    FROM ZI_LO05_07_Invoice AS sapi
    INNER JOIN @lt_supplierinv AS dt
            ON dt~PurchaseOrder = sapi~PurchaseOrder
            AND dt~PurchaseOrderitem = sapi~PurchaseOrderitem
    GROUP BY sapi~PurchaseOrder, sapi~PurchaseOrderitem, sapi~PurchaseOrderQuantityUnit
    INTO TABLE @DATA(lt_squantity).

***Process data
    DATA(lt_supplierdate) = lt_supplierinv.
    SORT lt_supplierdate BY PurchaseOrder
                           PurchaseOrderItem
                           PostingDate DESCENDING.

    DATA lt_inv  TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
    DATA lt_item TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line.
data: lv_tempamount type p DECIMALS 2.
    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<lf_data>).

      "update s-invoice
      LOOP AT lt_supplierinv INTO DATA(ls_inv)
        WHERE PurchaseOrder     = <lf_data>-PurchaseOrder
          AND PurchaseOrderItem = <lf_data>-PurchaseOrderItem.

        INSERT |{ ls_inv-SupplierInvoice }|     INTO TABLE lt_inv.
        INSERT |{ ls_inv-SupplierInvoiceItem }| INTO TABLE lt_item.
      ENDLOOP.

      <lf_data>-SupplierInvoice     = concat_lines_of( table = lt_inv  sep = `, ` ).
      <lf_data>-SupplierInvoiceItem = concat_lines_of( table = lt_item sep = `, ` ).
      CLEAR: lt_inv, lt_item.

      READ TABLE lt_supplierinv INTO DATA(ls_last)
        WITH KEY PurchaseOrder     = <lf_data>-PurchaseOrder
                 PurchaseOrderItem = <lf_data>-PurchaseOrderItem.

      IF sy-subrc = 0.
        <lf_data>-InvoiceDate = |{ ls_last-PostingDate DATE = USER }|.
        <lf_data>-InvoiceYear = ls_last-InvoiceYear.
      ENDIF.

*      READ TABLE lt_samount INTO DATA(ls_samout) WITH KEY PurchaseOrder = <lf_data>-PurchaseOrder
*                                                          PurchaseOrderItem = <lf_data>-PurchaseOrderitem.
*      IF sy-subrc = 0.
*        <lf_data>-DocumentCurrency_INV = ls_samout-DocumentCurrency.
*        <lf_data>-InvoiceAmount        = ls_samout-amount.
*      ENDIF.

      LOOP AT lt_samount INTO DATA(ls_samout)
        WHERE PurchaseOrder     = <lf_data>-PurchaseOrder
          AND PurchaseOrderItem = <lf_data>-PurchaseOrderItem.
          if ls_samout-ConditionRateRatio <> 0 .
            ls_samout-ConditionRateRatio = ls_samout-ConditionRateRatio / 100 .
          ENDIF.
          lv_tempamount = ls_samout-amount + ls_samout-SuplrInvcItmUnplndDelivCost + ( ( ls_samout-amount + ls_samout-SuplrInvcItmUnplndDelivCost ) * ls_samout-ConditionRateRatio ) .
          <lf_data>-InvoiceAmount += lv_tempamount.
          <lf_data>-DocumentCurrency_INV = ls_samout-DocumentCurrency.
      ENDLOOP.

      READ TABLE lt_squantity INTO DATA(ls_squantity) WITH KEY PurchaseOrder = <lf_data>-PurchaseOrder
                                                          PurchaseOrderItem = <lf_data>-PurchaseOrderitem.
      IF sy-subrc = 0.
        <lf_data>-PurchaseOrderQuantityUnit_EINV = ls_squantity-PurchaseOrderQuantityUnit.
        <lf_data>-QuantityInPurchaseOrderUnit        = ls_squantity-squantity.
      ENDIF.

      READ TABLE lt_longtext INTO DATA(ls_text) WITH KEY product = <lf_data>-ProductCode BINARY SEARCH.
      IF sy-subrc = 0.
        <lf_data>-zlongtext = ls_text-productlongtext.
      ENDIF.

      "Still to be delivered (qty)
      <lf_data>-Stilldelivered_qty = <lf_data>-OrderQuantity - <lf_data>-DeliveredQty . CONDENSE <lf_data>-Stilldelivered_qty.
      IF <lf_data>-Stilldelivered_qty < 0.
        <lf_data>-Stilldelivered_qty = '0'.
      ENDIF.

      "Still to be delivered (value)
      <lf_data>-Stilldelivered_value = <lf_data>-Stilldelivered_qty * <lf_data>-netpriceamount .

      "Still to be invoiced (qty)
      <lf_data>-StillInvoice_qty = <lf_data>-OrderQuantity - <lf_data>-QuantityInPurchaseOrderUnit .
      CONDENSE <lf_data>-StillInvoice_qty .
      IF <lf_data>-StillInvoice_qty < 0.
        <lf_data>-StillInvoice_qty  = '0'.
      ENDIF.

      "Still to be invoiced (value)
      <lf_data>-StillInvoice_value = <lf_data>-StillInvoice_qty * <lf_data>-netpriceamount .

      CONDENSE: <lf_data>-Stilldelivered_qty,
                <lf_data>-StillInvoice_qty .

    ENDLOOP.
    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.
ENDCLASS.
