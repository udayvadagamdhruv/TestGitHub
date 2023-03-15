public class PicklistPath {
	@AuraEnabled 
    public static case updateCase(Case c, String s){
        c.Status = s;
        upsert c;
        return c;
    }
}