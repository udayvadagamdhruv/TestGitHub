public with sharing class estimatedetailpageExt {

 public Estimate_Line_Items__c estlineitem {set;get;}
 public String Estid;
    public estimatedetailpageExt(ApexPages.StandardController controller) {

    Estid=controller.getrecord().id;
    estlineitem=[select id,name,Restrict__c,Approved__c from Estimate_Line_Items__c where id=:Estid];
    }

}