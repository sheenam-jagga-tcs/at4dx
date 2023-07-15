public interface  IContactsSelector extends IApplicationSObjectSelector {
    
    List<Contact> selectById( Set<Id> idSet );

    List<Contact> selectWithAccounts();
}