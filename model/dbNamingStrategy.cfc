component implements="cfide.orm.INamingStrategy" {

public string function getTableName(string tableName) {
    return '"' & tableName & '"';
}

public string function getColumnName(string columnName) {
    return '"' & columnName & '"';
}

}