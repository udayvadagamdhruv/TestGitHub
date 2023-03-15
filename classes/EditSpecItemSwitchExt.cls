public with sharing class EditSpecItemSwitchExt {

public string speitemid {set;get;}

    public EditSpecItemSwitchExt(ApexPages.StandardController controller) {
    
      speitemid=controller.getrecord().id;
    }

}