public with sharing class POSwitchExt {


  public string poid {set;get;}
  
    public POSwitchExt(ApexPages.StandardController controller) {
     poid=controller.getRecord().id;
     
    }

}