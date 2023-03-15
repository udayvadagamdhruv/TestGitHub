public with sharing class QuoteSwitchExt {


  public string Quoteid {set;get;}
    public QuoteSwitchExt(ApexPages.StandardController controller) {
       Quoteid =controller.getRecord().id;
    }

}