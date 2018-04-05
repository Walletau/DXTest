public without sharing class Mutex
{
	public static void Lock(String type)
	{
		List<Mutex__c> m = null;

		while(m == null)
		{
			try
			{
				m = [select Id from Mutex__c where Type__c =: type for update];
			}
			catch(QueryException e) {}

			// if this is the first time this type has been used we'll need to create a record to use
			if(m!= null && m.size() == 0)
			{
				try
				{
					insert new Mutex__c(Type__c = type);
				}
				catch (Exception e){}

				Lock(type);
			}
		}
	}
}