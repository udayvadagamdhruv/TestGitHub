public with sharing class EstimateSwitchExt {

    public string Estmid {set;get;}

    public EstimateSwitchExt(ApexPages.StandardController controller) {

      Estmid=controller.getRecord().id;
    }

}