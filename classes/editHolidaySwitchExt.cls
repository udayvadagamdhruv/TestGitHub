public with sharing class editHolidaySwitchExt {

public string holyid {set;get;}

    public editHolidaySwitchExt(ApexPages.StandardController controller) {

    holyid=controller.getRecord().id;
    }

}