// Lazaroiu Teodora-Bianca - 141
// Szmeteanca Eduard
// Codeblocks 20.03 GNU GCC

#include <iostream>
#include <vector>

using namespace std;

class citireSiAfisare // clasa abstracta pentru citire si afisare
{
public:
    citireSiAfisare() {}
    ~citireSiAfisare() {}

    friend istream& operator>> (istream& in, citireSiAfisare& inout);
    friend ostream& operator<< (ostream& out, const citireSiAfisare& inout);

    virtual void citireVirtuala (istream& in) = 0; // functie abstracta
    virtual void afisareVirtuala (ostream& out) const = 0; // functie abstracta
};
istream& operator>> (istream& in, citireSiAfisare& inout)
{
    inout.citireVirtuala(in);

    return in;
}
ostream& operator<< (ostream& out, const citireSiAfisare& inout)
{
    inout.afisareVirtuala(out);

    return out;
}

class malware : public citireSiAfisare
{
private:
    double rating;
    string data;
    string nume;
    string metodaDeInfectare;
    vector<string> registrii;
public:
    malware();
    malware(double rating, string data, string nume, string metodaDeInfectare, vector<string> registrii);
    malware (const malware &m);
    malware& operator= (const malware& m);
    ~malware();

    virtual void citireVirtuala (istream& in);
    virtual void afisareVirtuala (ostream& out) const;
};
malware::malware()
{
    rating = 0;
    data = "dd-mm-yyyy";
    nume = "";
    metodaDeInfectare = "unknown";
}
malware::malware(double rating, string data, string nume, string metodaDeInfectare, vector<string> registrii)
{
    this->rating = rating;
    this->data = data;
    this->nume = nume;
    this->metodaDeInfectare = metodaDeInfectare;
    for (int i = 0; i < registrii.size(); i++)
        this->registrii.push_back(registrii[i]);
}
malware::malware (const malware &m)
{
    this->rating = m.rating;
    this->data = m.data;
    this->nume = m.nume;
    this->metodaDeInfectare = m.metodaDeInfectare;
    for (int i = 0; i < m.registrii.size(); i++)
        this->registrii.push_back(m.registrii[i]);
}
malware& malware::operator= (const malware& m)
{
    if (this != &m)
    {
        this->registrii.clear();
        this->rating = m.rating;
        this->data = m.data;
        this->nume = m.nume;
        this->metodaDeInfectare = m.metodaDeInfectare;
        for (int i = 0; i < m.registrii.size(); i++)
            this->registrii.push_back(m.registrii[i]);
    }
    return *this;
}
malware::~malware()
{
    rating = 0;
    data = "dd-mm-yyyy";
    nume = "";
    metodaDeInfectare = "unknown";
    registrii.clear();
}
void malware::citireVirtuala (istream& in)
{
    cout<<"Rating: ";
    in>>rating;
    cout<<"Data: ";
    in>>data;
    cout<<"Nume: ";
    in>>nume;
    cout<<"Metoda de infectare: ";
    in>>metodaDeInfectare;
    cout<<"Registrii afectati (se va introducere 0 cand nu se mai doreste citirea): ";
    string reg;
    for (int i = 0; i < registrii.size() + 1; i++)
        {
            in>>reg;
            if (reg == "0") break;
            registrii.push_back(reg);
        }
    cout<<endl;

}
void malware::afisareVirtuala (ostream& out) const
{
    out<<"\nRating: "<<rating;
    out<<"\nData: "<<data;
    out<<"\nNume: "<<nume;
    out<<"\nMetoda de infectare: "<<metodaDeInfectare;
    out<<"\nRegistrii afectati: ";
    for (int i = 0; i < registrii.size(); i++)
        out<<registrii[i]<<" ";
    out<<endl;
}

class rootkit : public malware
{
private:
    vector <string> importuri;
    vector <string> semnificative;
public:
    rootkit();
    rootkit(vector <string> importuri, vector <string> semnificative);
    rootkit (const rootkit &r);
    rootkit& operator= (const rootkit& r);
    ~rootkit();

    virtual void citireVirtuala (istream& in);
    virtual void afisareVirtuala (ostream& out) const;
};
rootkit::rootkit() : malware()
{

}
rootkit::rootkit(vector <string> importuri, vector <string> semnificative) : malware()
{
    for (int i = 0 ; i < importuri.size(); i++)
        this->importuri.push_back(importuri[i]);
    for (int i = 0 ; i < semnificative.size(); i++)
        this->semnificative.push_back(semnificative[i]);
}
rootkit::rootkit (const rootkit &r) : malware(r)
{
    for (int i = 0 ; i < r.importuri.size(); i++)
        this->importuri.push_back(r.importuri[i]);
    for (int i = 0 ; i < r.semnificative.size(); i++)
        this->semnificative.push_back(r.semnificative[i]);
}
rootkit& rootkit::operator= (const rootkit& r)
{
    malware::operator =(r);
    if (this != &r)
    {
        for (int i = 0 ; i < r.importuri.size(); i++)
            this->importuri.push_back(r.importuri[i]);
        for (int i = 0 ; i < r.semnificative.size(); i++)
            this->semnificative.push_back(r.semnificative[i]);
    }
    return *this;
}
rootkit::~rootkit()
{
    importuri.clear();
    semnificative.clear();
}
void rootkit::citireVirtuala (istream& in)
{
    malware::citireVirtuala(in);
    cout<<"Importuri (se va introducere 0 cand nu se mai doreste citirea): ";
    string imp;
    for (int i = 0 ; i < importuri.size() + 1; i++)
        {
            in>>imp;
            if (imp == "0") break;
            importuri.push_back(imp);
        }
    cout<<"Semnificative (se va introducere 0 cand nu se mai doreste citirea): ";
    string semn;
    for (int i = 0 ; i < semnificative.size() + 1; i++)
        {
            in>>semn;
            if (semn == "0") break;
            semnificative.push_back(semn);
        }
}
void rootkit::afisareVirtuala (ostream& out) const
{
    malware::afisareVirtuala(out);
    out<<"Importuri: ";
    for (int i = 0 ; i < importuri.size(); i++)
        {
            out<<importuri[i]<<" ";
        }
    out<<"Semnificative: ";
    for (int i = 0 ; i < semnificative.size(); i++)
        {
            out<<semnificative[i]<<" ";
        }
}

class keylogger : public malware
{
private:
    vector <string> functii;
    vector <string> taste;
public:
    keylogger();
    keylogger(vector <string> functii, vector <string> taste);
    keylogger (const keylogger &k);
    keylogger& operator= (const keylogger& k);
    ~keylogger();

    virtual void citireVirtuala (istream& in);
    virtual void afisareVirtuala (ostream& out) const;
};
keylogger::keylogger() : malware()
{

}
keylogger::keylogger(vector <string> functii, vector <string> taste) : malware()
{
    for (int i = 0 ; i < functii.size(); i++)
        this->functii.push_back(functii[i]);
    for (int i = 0 ; i < taste.size(); i++)
        this->taste.push_back(taste[i]);
}
keylogger::keylogger (const keylogger &k) : malware(k)
{
    for (int i = 0 ; i < k.functii.size(); i++)
        this->functii.push_back(k.functii[i]);
    for (int i = 0 ; i < k.taste.size(); i++)
        this->taste.push_back(k.taste[i]);
}
keylogger& keylogger::operator= (const keylogger& k)
{
    malware::operator =(k);
    if (this != &k)
    {
        for (int i = 0 ; i < k.functii.size(); i++)
            this->functii.push_back(k.functii[i]);
        for (int i = 0 ; i < k.taste.size(); i++)
            this->taste.push_back(k.taste[i]);
    }
    return *this;
}
keylogger::~keylogger()
{
    functii.clear();
    taste.clear();
}
void keylogger::citireVirtuala (istream& in)
{
    malware::citireVirtuala(in);
    cout<<"functii (se va introducere 0 cand nu se mai doreste citirea): ";
    string imp;
    for (int i = 0 ; i < functii.size() + 1; i++)
        {
            in>>imp;
            if (imp == "0") break;
            functii.push_back(imp);
        }
    cout<<"taste (se va introducere 0 cand nu se mai doreste citirea): ";
    string tasta;
    for (int i = 0 ; i < taste.size() + 1; i++)
        {
            in>>tasta;
            if (tasta == "0") break;
            taste.push_back(tasta);
        }
}
void keylogger::afisareVirtuala (ostream& out) const
{
    malware::afisareVirtuala(out);
    out<<"functii: ";
    for (int i = 0 ; i < functii.size(); i++)
        {
            out<<functii[i]<<" ";
        }
    out<<"taste: ";
    for (int i = 0 ; i < taste.size(); i++)
        {
            out<<taste[i]<<" ";
        }
}

class calculator : public citireSiAfisare
{
private:
    static int contor;
    const int id;
    vector<malware> listaMalwares;
    double ratingFinal;
public:
    calculator();
    calculator(vector<malware> listaMalwares);
    calculator (const calculator &c);
    calculator& operator= (const calculator& c);
    ~calculator();

    virtual void citireVirtuala (istream& in);
    virtual void afisareVirtuala (ostream& out) const;
};
calculator::calculator() : id(contor++)
{
    ratingFinal = 0;
}
calculator::calculator(vector<malware> listaMalwares) : id(contor++)
{
    for (int i = 0; i < listaMalwares.size(); i++)
        this->listaMalwares.push_back(listaMalwares[i]);
}
calculator::calculator (const calculator &c) : id(contor++)
{
    this->ratingFinal = c.ratingFinal;
    for (int i = 0; i < c.listaMalwares.size(); i++)
        this->listaMalwares.push_back(c.listaMalwares[i]);
}
calculator& calculator::operator= (const calculator& c)
{
    if (this != &c)
    {
        this->ratingFinal = c.ratingFinal;
        for (int i = 0; i < c.listaMalwares.size(); i++)
            this->listaMalwares.push_back(c.listaMalwares[i]);
    }
    return *this;
}
calculator::~calculator()
{
    ratingFinal = 0;
    listaMalwares.clear();
}
void calculator::citireVirtuala (istream& in)
{
    cout<<"Lista malwares (se va introducere 0 cand nu se mai doreste citirea si 1 daca se doreste citirea inca unui malware): ";
    int ok;
    malware m;
    for (int i = 0; i < listaMalwares.size() + 1; i++)
    {
        cout<<"\n 0 sau 1: ";
        in>>ok;
        if (ok == 0) break;
        else
        {
            in>>m;
            listaMalwares.push_back(m);
        }
    }
}
void calculator::afisareVirtuala (ostream& out) const
{
    out<<"\nId unic: ";
    out<<id;
    out<<"\nRating final: ";
    out<<ratingFinal;
    out<<"\nLista malwares: ";
    for (int i = 0; i < listaMalwares.size(); i++)
    {
        out<<listaMalwares[i]<<endl;
    }
}

class meniu // singleton
{
private:
    static meniu* meniuMalware;
    meniu() {}
    meniu(const meniu &meniuMalware) = delete;
    meniu& operator= (const meniu &meniuMalware) = delete;
public:
    static meniu* getMeniu();
    void rulareMeniu();
    void stergereMeniu();
};
meniu* meniu::getMeniu()
{
    if (!meniuMalware) meniuMalware = new meniu();

    return meniuMalware;
}
void meniu::rulareMeniu() // programul principal
{
    calculator *listaCalculatoare[100];

    int k = 1;

    while (k == 1) // meniu interactiv
    {
        cout<<"-------------------------------------------------------\n";
        cout<<"Tasteaza 1 pentru a adauga un calculator\n";
        cout<<"Tasteaza 2 pentru a afisa toate calculatoarele\n";
        cout<<"Tasteaza 0 pentru a incheia programul\n";
        cout<<"-------------------------------------------------------\n";

        int comanda;

        static int n = 0;

        cin >> comanda;

        switch(comanda)
        {
            case 1:
            {
                listaCalculatoare[n] = new calculator;
                cin>>*listaCalculatoare[n];
                n++;
                break;
            }
            case 2:
            {
                for (int i = 0; i < n; i++)
                    cout<<*listaCalculatoare[i]<<endl;

                break;
            }
            case 0:
            {
                cout<<"program incheiat\n";

                k = 0;

                break;
            }
            default:
            {
                cout<<"incorect\n";

                break;
            }
        }
    }
}
void meniu::stergereMeniu()
{
    if (meniuMalware != NULL) delete meniuMalware;
}

meniu* meniu::meniuMalware = 0;

int calculator::contor = 1;

int main()
{
    meniu* meniuMalware = meniuMalware->getMeniu();
    meniuMalware->rulareMeniu();
    meniuMalware->stergereMeniu();

    return 0;
}
