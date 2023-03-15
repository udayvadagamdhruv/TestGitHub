public with sharing class EditProductionSpecTemplateExt {


 public string prospectempid {set;get;}
    public EditProductionSpecTemplateExt(ApexPages.StandardController controller) {
    
    prospectempid=controller.getRecord().id;
    }

}