@isTest
private class Mutex_Test
{
	@isTest static void testLock()
	{
		Test.startTest();

		Mutex.Lock('Test');
		System.assertEquals(1, [select Id from Mutex__c where Type__c = 'Test'].size());

		Mutex.Lock('Test');
		System.assertEquals(1, [select Id from Mutex__c where Type__c = 'Test'].size());

		Test.stopTest();
	}
}