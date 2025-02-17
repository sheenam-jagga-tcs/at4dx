public with sharing class ContactsSelector  extends ApplicationSObjectSelector
implements IContactsSelector {
    public static IContactsSelector newInstance()
    {
        return (IContactsSelector) Application.Selector.newInstance( Contact.SObjectType );
    }

    public Schema.sObjectType getSObjectType()
    {
        return Contact.SObjectType;
    }

    public override List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Contact.Id,
            Contact.Name
        };
    }

    private List<Schema.SObjectField> getAdditionalSObjectFieldList()
    {
        return new List<Schema.SObjectField> { };
    }

    public List<Contact> selectById(Set<Id> idSet)
    {
        return (List<Contact>) selectSObjectsById( idSet == null ? new Set<Id>() : idSet );
    }

    public List<Contact> selectWithAccounts()
	{
		fflib_QueryFactory contactsQueryFactory = newQueryFactory();

		
			
		new AccountsSelector().
			configureQueryFactoryFields(contactsQueryFactory, 'Account');
		system.debug('contactsQueryFactory::'+contactsQueryFactory.toSOQL());
		return (List<Contact>) Database.query(
			contactsQueryFactory.toSOQL());
	}
}