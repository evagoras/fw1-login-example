component persistent=true entityName="User" table="user" {

	property name="ID" generator="increment" setter=false;
	property name="firstName";
	property name="lastName";
	property name="email";
	property name="passwordHash";
	property name="passwordSalt";
	property name="token" column="token";

}