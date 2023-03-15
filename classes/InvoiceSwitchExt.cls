public with sharing class InvoiceSwitchExt {

public string invid {set;get;}
    public InvoiceSwitchExt(ApexPages.StandardController controller) {
    invid=controller.getRecord().id;
    }

}