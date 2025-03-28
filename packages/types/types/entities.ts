// Base interfaces that match the database schema
export interface User {
    id: number
    email: string
    active: boolean
    name: string
    firstName: string
    initials: string
    archived: boolean
    createdAt?: Date
    updatedAt?: Date
}

export interface Activity {
    id: number
    categoryId: number
    taskId: number
    userId: number
    invoiceId: number
    date: Date
    duration: number
    actualDuration: number
    billedDuration: number
    startTime: Date
    endTime: Date
    isFullDay: boolean
    description: string
    amount: number
    expense: number
    rate: number
    isReplicable: boolean
    autoDistribution: boolean
    billingMode: string
    report: string
    validationStatus: string
    validationUserId: number
    validationDateTime: Date
    userExpense: number
    billingExpense: number
    costPrice: number
    costValue: number
    templateName: string
    isTemplate: boolean
    scheduledActivityId: number
    externalKey: string
    uid: string
    forceBillingData: boolean
    isNegative: boolean
    createdAt: Date
    updatedAt: Date
    createdBy: number
    updatedBy: number
    profitabilityAmount: number
    profitabilityRate: number
    profitabilityDuration: number
    privateReplicable: boolean
    useDescriptionAsObjectReplicable: boolean
    outlookAppointmentStatus: string
}

export interface Project {
    id: number
    accountId: number
    shortDescription: string
    name: string
    description: string
    archived: boolean
    order: number
    billingMandate: string
    rateId: number
    generateDocument: boolean
    commercialDocumentTemplateId: number
    isTemplate: boolean
    templateName: string
    notes: string
    referentUserId: number
    validateActivityWithOverage: boolean
    taskRateEntry: string
    externalKey: string
    invoiceTextTemplateId: number
    isEntryForbidden: boolean
    createdAt: Date
    updatedAt: Date
    createdBy: number
    updatedBy: number
    billingContactId: number
    totalDuration?: number
    unBilledDuration?: number
    firstActivityDate?: Date | null
    lastActivityDate?: Date | null
}

export interface Expense {
    id: number
    name: string
    shortDescription: string
    description: string
    expenseType: string
    amount: number
    unit: string
    archived: boolean
    defaultQuantity: number
    articleId: number
    taxTypeId: number
    expenseMode: string
    billingAmount: number
    useBillingAmount: boolean
    salaryRubricId: number
    label: string
    createdAt: Date
    updatedAt: Date
    createdBy: number
    updatedBy: number
}

export interface Client {
    id: number
    shortDescription: string
    name: string
    email: string
    email2: string
    email3: string
    website: string
    address1: string
    address2: string
    postalCode: string
    city: string
    phone1: string
    phone2: string
    phone3: string
    phone4: string
    description: string
    contactId: number
    archived: boolean
    externalKey: string
    companyTypeId: number
    turnover: number
    employeeCount: number
    referentUserId: number
    regionId: number
    fax: string
    companyNotes: string
    countryId: number
    since: Date
    checkDate: Date
    mutationBaseId: number
    accountCategoryId: number
    poBox: string
    mobilePhone: string
    languageId: number
    bankRelation: string
    instituteName: string
    instituteAddress: string
    institutePostalCode: string
    instituteCity: string
    iban: string
    accountNumber: string
    clearingNumber: string
    swift: string
    instituteNotes: string
    postAccountBank: string
    ldapReplicable: boolean
    exchangeReplicable: boolean
    winBIZReplicable: boolean
    companyCreationDate: Date
    companyTerminationDate: Date
    externalKey2: string
    externalKey3: string
    ide: string
    companyTerminationReasonId: number
    gln: string
    createdAt: Date
    updatedAt: Date
    createdBy: number
    updatedBy: number
    ideSite: string
}

export interface Rate {
    id: number
    name: string
    amount: number
    archived: boolean
    createdAt: Date
    updatedAt: Date
    createdBy: number
    updatedBy: number
}

export interface Task {
    id: number
    billingMode: string
    taskType: string
    taskBilling: string
    projectTaskLink: string
    outlookReplication: string
    negativeHour: string
    shortDescription: string
    name: string
    description: string
    rate: number
    color: number
    archived: boolean
    order: number
    invoiceColor: number
    useInvoiceColor: boolean
    durationRequired: boolean
    articleId: number
    unit: string
    managerValidation: boolean
    activityReportTemplateId: number
    salaryRubricId: number
    zeroHour: boolean
    durationMode: string
    fixedDuration: number
    label: string
    validationColor: number
    useValidationColor: boolean
    createdAt: Date
    updatedAt: Date
    createdBy: number
    updatedBy: number
}
