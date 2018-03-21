public class AccountMergingBatch implements Database.Batchable<Object>, Schedulable
{
	String query;

	public static void scheduleHourly()
	{
		System.schedule(Test.isRunningTest() ? 'TestRun' : 'Account Merging Hourly', '0 0 * * * ?', new AccountMergingBatch());
	}

	public void execute(SchedulableContext SC)
	{
		Database.executeBatch(new AccountMergingBatch(), 150);
	}

	public AccountMergingBatch()
	{
		query = 'select Id, Master__c from Account where Master__c != null';
	}

	public Iterable<Object> start(Database.BatchableContext BC)
	{
		return (Iterable<Object>)Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext BC, List<Object> scope)
	{
		Map<Id, SObject> masterAccounts = new Map<Id, SObject>();

		for(SObject s : (List<SObject>)scope)
		{
			masteraccounts.put((Id)s.get('Master__c'), null);
		}

		masterAccounts = new Map<Id, SObject>([select Id from Account where Id in : masterAccounts.keySet()]);

		for(SObject s : (List<SObject>)scope)
		{
			SObject master = masterAccounts.get((Id)s.get('Master__c'));
			Database.merge(master, s);
		}
	}

	public void finish(Database.BatchableContext BC)
	{

	}
}