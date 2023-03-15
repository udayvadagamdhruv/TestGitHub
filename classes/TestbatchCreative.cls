@istest(seealldata=true)
public class TestbatchCreative
{
    static testmethod void test1()
    {
        batchCreative bc=new batchCreative();
       // bc=new batchCreative();
        database.executebatch(bc,200);
    }
}