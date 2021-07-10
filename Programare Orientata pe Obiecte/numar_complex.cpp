#include <iostream>
#include <cmath>

using namespace std;

class numar_complex
{
    double re, im;
public:
    numar_complex();
    numar_complex(double re, double im);
    numar_complex(const numar_complex& z);
    ~numar_complex();

    void set_real();
    void set_imaginar();
    void afisare();
    double get_real();
    double get_imaginar();
    double modul();
};

numar_complex::numar_complex()
    {
        re = 0;
        im = 0;
    }

numar_complex::numar_complex(double re, double im)
    {
        this->re = re;
        this->im = im;
    }

numar_complex::numar_complex(const numar_complex& z)
{
    this->re = z.re;
    this->im = z.im;
}

numar_complex::~numar_complex()
{
    re = 0;
    im = 0;
}

void numar_complex::set_real()
{
    cout<<"partea reala: ";
    cin>> re;
}

void numar_complex::set_imaginar()
{
    cout<<"partea imaginara: ";
    cin>> im;
}

void numar_complex::afisare()
    {
        cout<<re<<" + "<<im<<"i";
        cout<<endl;
    }

double numar_complex::get_real()
{
    return re;
}

double numar_complex::get_imaginar()
{
    return im;
}

double numar_complex::modul()
{
    return sqrt(re*re+im*im);
}


int main()
{
    numar_complex z(2,3); // constructor cu parametri
    numar_complex y(z); // constructor de copiere
    y.afisare();
}
