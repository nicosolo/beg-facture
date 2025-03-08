import knex from "knex"

export const odysDb = knex({
    client: "mssql",
    connection: {
        server: process.env.MSSQL_SERVER,
        user: process.env.MSSQL_USER,
        password: process.env.MSSQL_PASSWORD,
        database: process.env.MSSQL_DATABASE,
        port: parseInt(process.env.MSSQL_PORT || "1433"),
        options: {
            encrypt: true,
        },
    },
})
