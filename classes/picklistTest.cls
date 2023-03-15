public class picklistTest{
    public String selectedVal {get;set;}
    public List<SelectOption> getOptions1(){
        List<SelectOption> retVal = new List<SelectOption>();
        for(Integer i = 0; i < 1000; ++i){
            retVal.add(new SelectOption(String.valueOf(i+1), String.valueOf(i+1)));
        }
        return retVal;
    }
    public List<SelectOption> getOptions2(){
        List<SelectOption> retVal = new List<SelectOption>();
        for(Account a : [SELECT Id, Name FROM Account]){
            retVal.add(new SelectOption(a.Id, a.Name));
        }
        return retVal;
    }
    public List<SelectOption> getOptions3(){
        List<SelectOption> retVal = new List<SelectOption>();
        for(Contact c : [SELECT Id, LastName FROM Contact]){
            retVal.add(new SelectOption(c.Id, c.LastName));
        }
        return retVal;
    }
}