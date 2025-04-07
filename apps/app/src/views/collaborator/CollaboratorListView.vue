<template>
    <div class="container mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Liste des collaborateurs</h1>
            <Button variant="primary" :to="{ name: 'collaborator-new' }">
                Nouveau collaborateur
            </Button>
        </div>

        <DataTable
            :items="collaborators"
            :columns="columns"
            item-key="IDcollaborateur"
            empty-message="Aucun collaborateur trouvé"
        >
            <template #cell:fullName="{ item }"> {{ item.Prénom }} {{ item.Nom }} </template>

            <template #cell:actions="{ item }">
                <div class="flex justify-end gap-2">
                    <Button
                        variant="ghost"
                        size="sm"
                        :to="{ name: 'collaborator-edit', params: { id: item.IDcollaborateur } }"
                        className="text-indigo-600 hover:text-indigo-900"
                    >
                        Modifier
                    </Button>
                </div>
            </template>
        </DataTable>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import Button from "../../components/atoms/Button.vue"
import DataTable from "../../components/molecules/DataTable.vue"

interface Collaborator {
    IDcollaborateur: number
    Prénom: string
    Nom: string
    Initiales: string
    "Mot de passe": string
}

const columns = [
    { key: "IDcollaborateur", label: "ID", width: "w-1/3" as "w-1/3" },
    { key: "fullName", label: "Nom complet" },
    { key: "Initiales", label: "Initiales" },
    { key: "actions", label: "Actions" },
]

const collaborators = ref<Collaborator[]>([
    {
        IDcollaborateur: 80,
        Prénom: "Adrien",
        Nom: "Jeannerat",
        Initiales: "aje",
        "Mot de passe": "aje",
    },
    {
        IDcollaborateur: 63,
        Prénom: "Adrien",
        Nom: "Pantet",
        Initiales: "ap",
        "Mot de passe": "ap",
    },
    {
        IDcollaborateur: 49,
        Prénom: "Alexis",
        Nom: "Jaspar",
        Initiales: "aj",
        "Mot de passe": "aj",
    },
    {
        IDcollaborateur: 78,
        Prénom: "Anais",
        Nom: "Loux",
        Initiales: "al",
        "Mot de passe": "al",
    },
    {
        IDcollaborateur: 87,
        Prénom: "Anna",
        Nom: "Rauch",
        Initiales: "arh",
        "Mot de passe": "arh",
    },
    {
        IDcollaborateur: 80,
        Prénom: "Adrien",
        Nom: "Jeannerat",
        Initiales: "aje",
        "Mot de passe": "aje",
    },
    { IDcollaborateur: 63, Prénom: "Adrien", Nom: "Pantet", Initiales: "ap", "Mot de passe": "ap" },
    { IDcollaborateur: 49, Prénom: "Alexis", Nom: "Jaspar", Initiales: "aj", "Mot de passe": "aj" },
    { IDcollaborateur: 78, Prénom: "Anais", Nom: "Loux", Initiales: "al", "Mot de passe": "al" },
    { IDcollaborateur: 87, Prénom: "Anna", Nom: "Rauch", Initiales: "arh", "Mot de passe": "arh" },
    {
        IDcollaborateur: 60,
        Prénom: "Anthony",
        Nom: "Salamin",
        Initiales: "as",
        "Mot de passe": "as",
    },
    { IDcollaborateur: 57, Prénom: "Arnaud", Nom: "Dorsaz", Initiales: "ad", "Mot de passe": "ad" },
    {
        IDcollaborateur: 79,
        Prénom: "Augustine",
        Nom: "Raymond",
        Initiales: "ara",
        "Mot de passe": "ara",
    },
    {
        IDcollaborateur: 32,
        Prénom: "Barbara",
        Nom: "Lengyel",
        Initiales: "bl",
        "Mot de passe": "bl",
    },
    {
        IDcollaborateur: 34,
        Prénom: "Battista",
        Nom: "Matasci",
        Initiales: "bm",
        "Mot de passe": "bm",
    },
    { IDcollaborateur: 76, Prénom: "Céline", Nom: "Posse", Initiales: "cp", "Mot de passe": "cp" },
    {
        IDcollaborateur: 36,
        Prénom: "Charlène",
        Nom: "Gaillard",
        Initiales: "cg",
        "Mot de passe": "cg",
    },
    {
        IDcollaborateur: 15,
        Prénom: "Christophe",
        Nom: "Badertscher",
        Initiales: "cb",
        "Mot de passe": "cb",
    },
    { IDcollaborateur: 35, Prénom: "Clara", Nom: "Chauvet", Initiales: "cc", "Mot de passe": "cc" },
    {
        IDcollaborateur: 85,
        Prénom: "Clémence",
        Nom: "Maire",
        Initiales: "cma",
        "Mot de passe": "cma",
    },
    {
        IDcollaborateur: 83,
        Prénom: "Daniela",
        Nom: "Bornet",
        Initiales: "dbo",
        "Mot de passe": "dbo",
    },
    { IDcollaborateur: 37, Prénom: "Debora", Nom: "Janos", Initiales: "dj", "Mot de passe": "dj" },
    { IDcollaborateur: 21, Prénom: "Didier", Nom: "Cardis", Initiales: "dc", "Mot de passe": "dc" },
    {
        IDcollaborateur: 46,
        Prénom: "Dimitri",
        Nom: "Giugni",
        Initiales: "dg",
        "Mot de passe": "dg",
    },
    { IDcollaborateur: 42, Prénom: "Erika", Nom: "Aymon", Initiales: "ea", "Mot de passe": "ea" },
    {
        IDcollaborateur: 26,
        Prénom: "Filipe",
        Nom: "Carrasco",
        Initiales: "fc",
        "Mot de passe": "fc",
    },
    {
        IDcollaborateur: 56,
        Prénom: "Florian",
        Nom: "Humair",
        Initiales: "fh",
        "Mot de passe": "fh",
    },
    {
        IDcollaborateur: 33,
        Prénom: "François",
        Nom: "Negro",
        Initiales: "fn",
        "Mot de passe": "fn",
    },
    {
        IDcollaborateur: 7,
        Prénom: "Frank",
        Nom: "Philippossian",
        Initiales: "fp",
        "Mot de passe": "fop",
    },
    {
        IDcollaborateur: 70,
        Prénom: "Frederic",
        Nom: "Poirrier",
        Initiales: "fpo",
        "Mot de passe": "fpo",
    },
    {
        IDcollaborateur: 16,
        Prénom: "Grégory",
        Nom: "Grosjean",
        Initiales: "gg",
        "Mot de passe": "gg",
    },
    {
        IDcollaborateur: 73,
        Prénom: "Guillaume",
        Nom: "Massy",
        Initiales: "gm",
        "Mot de passe": "gm",
    },
    { IDcollaborateur: 28, Prénom: "Hélène", Nom: "Mas", Initiales: "hm", "Mot de passe": "hm" },
    {
        IDcollaborateur: 25,
        Prénom: "Jacques",
        Nom: "Bechet",
        Initiales: "jb",
        "Mot de passe": "jb",
    },
    {
        IDcollaborateur: 68,
        Prénom: "Jacques1",
        Nom: "Philipossian1",
        Initiales: "jp",
        "Mot de passe": "jp",
    },
    {
        IDcollaborateur: 59,
        Prénom: "JacquesAndre",
        Nom: "Lanet",
        Initiales: "jal",
        "Mot de passe": "jal",
    },
    { IDcollaborateur: 2, Prénom: "Jean", Nom: "Savary", Initiales: "js", "Mot de passe": "moi" },
    {
        IDcollaborateur: 22,
        Prénom: "Jérémie",
        Nom: "Pralong",
        Initiales: "jpr",
        "Mot de passe": "jpr",
    },
    { IDcollaborateur: 19, Prénom: "Julien", Nom: "Richon", Initiales: "jr", "Mot de passe": "jr" },
    {
        IDcollaborateur: 23,
        Prénom: "Julien",
        Nom: "Travelletti",
        Initiales: "jt",
        "Mot de passe": "jt",
    },
    { IDcollaborateur: 43, Prénom: "Katia", Nom: "Ferro", Initiales: "kf", "Mot de passe": "kf" },
    {
        IDcollaborateur: 54,
        Prénom: "Laurence",
        Nom: "Fischer",
        Initiales: "lf",
        "Mot de passe": "lf",
    },
    { IDcollaborateur: 39, Prénom: "Léa", Nom: "Perrochet", Initiales: "lp", "Mot de passe": "lp" },
    { IDcollaborateur: 6, Prénom: "Liliane", Nom: "Bianco", Initiales: "lb", "Mot de passe": "lb" },
    {
        IDcollaborateur: 82,
        Prénom: "Lina",
        Nom: "Klochko",
        Initiales: "lkl",
        "Mot de passe": "lkl",
    },
    { IDcollaborateur: 75, Prénom: "Lisa", Nom: "Coianiz", Initiales: "lc", "Mot de passe": "lc" },
    {
        IDcollaborateur: 64,
        Prénom: "Margaux",
        Nom: "Dubois",
        Initiales: "mxd",
        "Mot de passe": "mxd",
    },
    {
        IDcollaborateur: 27,
        Prénom: "Maria",
        Nom: "Fonticoba",
        Initiales: "mf",
        "Mot de passe": "mf",
    },
    {
        IDcollaborateur: 47,
        Prénom: "Marion",
        Nom: "Cochand",
        Initiales: "mc",
        "Mot de passe": "mc",
    },
    { IDcollaborateur: 40, Prénom: "Martin", Nom: "Franz", Initiales: "fm", "Mot de passe": "fm" },
    {
        IDcollaborateur: 86,
        Prénom: "Mathieu",
        Nom: "Girard",
        Initiales: "mgi",
        "Mot de passe": "mgi",
    },
    {
        IDcollaborateur: 81,
        Prénom: "Maxime",
        Nom: "Mignot",
        Initiales: "mmi",
        "Mot de passe": "mmi",
    },
    { IDcollaborateur: 9, Prénom: "Michael", Nom: "Digout", Initiales: "md", "Mot de passe": "md" },
    {
        IDcollaborateur: 52,
        Prénom: "Michelangelo",
        Nom: "De Boni",
        Initiales: "mdb",
        "Mot de passe": "mdb",
    },
    {
        IDcollaborateur: 74,
        Prénom: "Morgane",
        Nom: "Dumont",
        Initiales: "mdu",
        "Mot de passe": "mdu",
    },
    { IDcollaborateur: 45, Prénom: "Noémie", Nom: "Simon", Initiales: "ns", "Mot de passe": "ns" },
    { IDcollaborateur: 38, Prénom: "Oliver", Nom: "Tomson", Initiales: "ot", "Mot de passe": "ot" },
    { IDcollaborateur: 62, Prénom: "Pascal", Nom: "Perolo", Initiales: "pp", "Mot de passe": "pp" },
    { IDcollaborateur: 48, Prénom: "Pascale", Nom: "Girod", Initiales: "pg", "Mot de passe": "pg" },
    {
        IDcollaborateur: 29,
        Prénom: "Patricia",
        Nom: "Conus",
        Initiales: "pc",
        "Mot de passe": "pc",
    },
    { IDcollaborateur: 8, Prénom: "Régis", Nom: "Monnet", Initiales: "mo", "Mot de passe": "mo" },
    {
        IDcollaborateur: 44,
        Prénom: "Renaud",
        Nom: "Saint-Loup",
        Initiales: "rsl",
        "Mot de passe": "rsl",
    },
    { IDcollaborateur: 41, Prénom: "Roel", Nom: "Verberne", Initiales: "rv", "Mot de passe": "rv" },
    { IDcollaborateur: 24, Prénom: "Romain", Nom: "Sonney", Initiales: "rs", "Mot de passe": "rs" },
    {
        IDcollaborateur: 55,
        Prénom: "Salahaddin",
        Nom: "Ahmadirad",
        Initiales: "sa",
        "Mot de passe": "sa",
    },
    {
        IDcollaborateur: 58,
        Prénom: "Samanta",
        Nom: "Cacciatore",
        Initiales: "sc",
        "Mot de passe": "sc",
    },
    {
        IDcollaborateur: 50,
        Prénom: "Sarah",
        Nom: "Dornberger",
        Initiales: "sd",
        "Mot de passe": "sd",
    },
    {
        IDcollaborateur: 17,
        Prénom: "Sébastien",
        Nom: "Simoens",
        Initiales: "ss",
        "Mot de passe": "ss",
    },
    { IDcollaborateur: 20, Prénom: "STAGE", Nom: "HIER", Initiales: "sh", "Mot de passe": "sh" },
    {
        IDcollaborateur: 71,
        Prénom: "Tamara",
        Nom: "Veuthey",
        Initiales: "tv",
        "Mot de passe": "tv",
    },
    { IDcollaborateur: 51, Prénom: "Tess", Nom: "Calderon", Initiales: "tc", "Mot de passe": "tc" },
    { IDcollaborateur: 72, Prénom: "Tibaud", Nom: "Rey", Initiales: "tr", "Mot de passe": "tr" },
    {
        IDcollaborateur: 65,
        Prénom: "Valentin",
        Nom: "Dall'Alba",
        Initiales: "vd",
        "Mot de passe": "vd",
    },
    {
        IDcollaborateur: 84,
        Prénom: "Van Duy",
        Nom: "Tran",
        Initiales: "vtr",
        "Mot de passe": "vtr",
    },
    {
        IDcollaborateur: 31,
        Prénom: "Vincent",
        Nom: "Boitelet",
        Initiales: "vb",
        "Mot de passe": "vb",
    },
    {
        IDcollaborateur: 69,
        Prénom: "Yasin",
        Nom: "Khanabeigi",
        Initiales: "yk",
        "Mot de passe": "yk",
    },
])
</script>
