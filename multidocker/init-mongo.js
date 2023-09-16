db.createUser(
    {
        user: "dbsiteaccount",
        pwd: "$password!123",
        roles: [
            {
                role: "readWrite",
                db: "user"
            }
        ]
    }
)