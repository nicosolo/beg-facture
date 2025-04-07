export default {
    common: {
        loading: "Chargement...",
        save: "Enregistrer",
        cancel: "Annuler",
        delete: "Supprimer",
        edit: "Modifier",
        create: "Créer",
        search: "Rechercher",
        filter: "Filtrer",
        actions: "Actions",
        confirm: "Confirmer",
        yes: "Oui",
        no: "Non",
        submit: "Soumettre",
        back: "Retour",
        next: "Suivant",
        previous: "Précédent",
        notAvailable: "N/D",
    },
    navigation: {
        home: "Accueil",
        about: "À propos",
        projects: "Mandats",
        clients: "Clients",
        invoices: "Factures",
        collaborators: "Collaborateurs",
        settings: "Paramètres",
        activities: "Activités",
        tariffs: "Tarifs",
        time: "Heures",
    },
    projects: {
        title: "Mandats",
        list: "Liste des projets",
        create: "Créer un projet",
        new: "Nouveau mandat",
        edit: "Modifier le mandat",
        details: "Détails du mandat",
        name: "Nom du mandat",
        mandat: "Numéro mandat",
        date: "Date de début",
        designation: "Désignation",
        locality: "Localité",
        client: "Client",
        engineer: "Ingénieur",
        enterprise: "Entreprise",
        type: "Type",
        responsible: "Responsable",
        invoice: "Adresse de facturation",
        remark: "Remarque",
        print: "Imprimer",
        description: "Description",
        shortDescription: "Description courte",
        billingMandate: "Mandat de facturation",
        order: "Ordre",
        referentUser: "Responsable",
        selectReferentUser: "Sélectionner un responsable",
        archived: "Archivé",
        generateDocument: "Générer document",
        validateActivityWithOverage: "Valider activité avec dépassement",
        notes: "Notes",
        statusLabel: "Statut",
        startDate: "Date de début",
        endDate: "Date de fin",
        budget: "Budget",
        totalDuration: "Durée totale",
        unBilledDuration: "Heures non facturées",
        firstActivity: "Première activité",
        lastActivity: "Dernière activité",
        actions: "Actions",
        noProjectsFound: "Aucun projet trouvé correspondant à vos critères.",
        filters: {
            title: "Filtres",
            status: "Statut",
            client: "Client",
            dateRange: "Période",
            apply: "Appliquer",
            reset: "Réinitialiser les filtres",
            sortBy: "Trier par",
            ascending: "Croissant",
            descending: "Décroissant",
            fromDate: "Date de début",
            toDate: "Date de fin",
            includeArchived: "Inclure les archivés",
            searchByName: "Rechercher par nom",
            referentUser: "Responsable",
            selectReferentUser: "Sélectionner un responsable",
        },
        status: {
            all: "Tous",
            active: "Actif",
            completed: "Terminé",
            cancelled: "Annulé",
            onHold: "En attente",
            archived: "Archivé",
        },
    },
    pagination: {
        showing: "Affichage de {from} à {to} sur {total} éléments",
        itemsPerPage: "Éléments par page",
        next: "Suivant",
        previous: "Précédent",
        page: "Page",
    },
    errors: {
        general: "Une erreur est survenue",
        notFound: "Page non trouvée",
        unauthorized: "Non autorisé",
        required: "Ce champ est requis",
        invalid: "Ce champ est invalide",
        networkError: "Erreur de connexion au serveur",
    },
    validation: {
        required: "Ce champ est requis",
        invalid: "Ce champ est invalide",
        min: "La valeur doit être au moins {min}",
        max: "La valeur doit être au plus {max}",
        minLength: "Le texte doit comporter au moins {min} caractères",
        maxLength: "Le texte doit comporter au plus {max} caractères",
        email: "L'adresse email n'est pas valide",
        url: "L'URL n'est pas valide",
        number: "La valeur doit être un nombre",
        integer: "La valeur doit être un nombre entier",
    },
}
