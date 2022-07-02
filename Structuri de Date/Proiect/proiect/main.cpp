/*
    Folosim structura treap = arbore binar cu chei si prioritati cu proprietatea ca:
        -- treapul este un arbore de cautare pentru chei
        -- treapul este un max-heap pentru proprietati
*/
#include <iostream>
#include <fstream>         // biblioteca folosita pentru utilizarea fisierelor pentru citire/scriere
#define MAX 2147483647
#define MIN -2147483647
#define INF MAX         // INF-ul devine cea mai mare valoare pe care o poate lua un int
using namespace std;
int maxim(int a, int b)            //functia de maxim folosita la predecesor
{
    if(a > b)return a;
    return b;
}
int minim(int a, int b)             //functia de minim folosita la succesor
{
    if(a < b)return a;
    return b;
}
struct Nod
{
    int key;
    int priority;
    int weight;        // greutatea sub-arborelui din treap avand ca radacina Nod, folositoare in gasirea cardinalului in O(1)
    Nod* left_son;
    Nod* right_son;
};
Nod* nil = NULL;
struct treap
{
    Nod* root;           //radacina
    void insert(int x)                   //insertion function
    {
        insertion(root, x);
    }
    void insertion(Nod* & node, int x)
    {
        if(node == nil)
        {
            node = new Nod;
            node -> key = x;
            node -> priority = rand();        // priority is a random number
            node -> weight = 1;
            node -> left_son = NULL;
            node -> right_son = NULL;
            return;
        }
        if(x <= node -> key)insertion(node -> left_son, x);
        else insertion(node -> right_son, x);
        node -> weight = 1;
        if(node -> left_son != nil)node -> weight = node -> weight + node -> left_son -> weight;
        if(node -> right_son != nil)node -> weight = node -> weight + node -> right_son -> weight;

        balance(node);            //rebalanseaza arborele prin rotatii ca sa fie un max-heap dupa prioritati
    }
    void balance(Nod* & node)
    {
        if(node -> left_son != nil && node -> left_son -> priority > node -> priority)rotate_left(node);
        else if(node -> right_son != nil && node -> right_son -> priority > node -> priority)rotate_right(node);
    }
    void rotate_left(Nod* & node)
    {
        int weight_aux = 1;
        if(node -> left_son -> right_son != nil)weight_aux += node -> left_son -> right_son -> weight;
        if(node -> right_son != nil)weight_aux += node -> right_son -> weight;
        Nod* aux = node -> left_son;
        aux -> weight = node -> weight;
        node -> left_son = aux -> right_son, aux -> right_son = node;
        node = aux;
        node -> right_son -> weight = weight_aux;
    }
    void rotate_right(Nod* & node)
    {
        int weight_aux = 1;
        if(node -> right_son -> left_son != nil)weight_aux += node -> right_son -> left_son -> weight;
        if(node -> left_son != nil)weight_aux += node -> left_son -> weight;
        Nod* aux = node -> right_son;
        aux -> weight = node -> weight;
        node -> right_son = aux -> left_son, aux -> left_son = node;
        node = aux;
        node -> left_son -> weight = weight_aux;
    }
    void erase(int x)                         //delete function
    {
        eraser(root, x);
    }
    void eraser(Nod* & node, int x)
    {
        if(node == nil)return;
        if(x < node -> key)eraser(node -> left_son, x);
        else if(x > node -> key)eraser(node -> right_son, x);
        else
        {
            if(node -> left_son == nil && node -> right_son == nil)
            {
                delete node;                        // stergerea efectiva
                node = nil;
                //cout << "Delete successfull!\n";
                return;
            }
            else if(node -> left_son == nil)
            {
                rotate_right(node);
                eraser(node, x);
            }
            else if(node -> right_son == nil)
            {
                rotate_left(node);
                eraser(node, x);
            }
            else if(node -> left_son -> priority > node -> right_son -> priority)
            {
                rotate_left(node);
                eraser(node, x);
            }
            else
            {
                rotate_right(node);
                eraser(node, x);
            }
        }
        node -> weight = 1;
        if(node -> left_son != nil)node -> weight = node -> weight + node -> left_son -> weight;
        if(node -> right_son != nil)node -> weight = node -> weight + node -> right_son -> weight;
    }
    int minn()
    {
        if(root == nil)return 0;
        Nod* aux = root;
        while(aux -> left_son != nil)
            aux = aux -> left_son;
        return aux -> key;
    }
    int maxx()
    {
        if(root == nil)return 0;
        Nod* aux = root;
        while(aux -> right_son != nil)
            aux = aux -> right_son;
        return aux -> key;
    }
    int succesor(int x)
    {
        return aux_suc(root, x);
    }
    int aux_suc(Nod* & node, int x)
    {
        if(node == nil)return MAX;
        if(node -> key >= x)return minim(node -> key, aux_suc(node -> left_son, x));
        else return aux_suc(node -> right_son, x);
    }
    int predecesor(int x)
    {
        return aux_predd(root, x);
    }
    int aux_predd(Nod* & node, int x)
    {
        if(node == nil)return MIN;
        if(node -> key <= x)return maxim(node -> key, aux_predd(node -> right_son, x));
        else return aux_predd(node -> left_son, x);
    }
    int k_element(int poz)
    {
        bool found = false;
        int aux = find_elem_of(root, poz, found);
        if(found == false)return -INF;
        return aux;
    }
    int find_elem_of(Nod* & node, int poz, bool & found)
    {
        if(node == nil)return 0;
        int aux;
        if(node -> left_son != nil)aux = node -> left_son -> weight;
        else aux = 0;
        if(aux + 1 == poz)
        {
            found = true;
            return node -> key;
        }
        if(aux + 1 < poz)return find_elem_of(node -> right_son, poz - aux - 1, found);
        else return find_elem_of(node -> left_son, poz, found);
    }
    int cardinal()
    {
        if(root == nil)return 0;
        return root -> weight;
    }
    int este_in(int x)
    {
        return este_in_search(root, x);
    }
    int este_in_search(Nod* & node, int x)
    {
        if(node == nil)return 0;
        if(node -> key == x)return 1;
        if(node -> key > x)return este_in_search(node -> left_son, x);
        else return este_in_search(node -> right_son, x);
    }
};
treap S;
int i, q, op, x, k, aux, prev_op;
int coada[1000005], marime;
int main()
{
    /*
    ofstream F("treap.in");
    //int coada[1000005], marime = 0;
    q = 1000000;
    F << q << "\n";
    for(i = 1; i <= q; i ++)
    {
        if(i <= 1000)       // pana la sqrt(q) favorizam insert urile
        {
            aux = rand() % 2;
            if(aux == 0)op = 1;
            else op = rand() % 9 + 1;
        }
        else              // dupa sqrt(q) scadem insertiile (numai aprox 66% vor fi pastrate)
        {
            op = rand() % 9 + 1;
            if(op == 1)
            {
                op = rand() % 3 + 1;
                if(op == 2)op = rand() % 8 + 2;     // [2,9]
                else op = 1;
            }
        }
        while(prev_op == op && (op == 3 || op == 4 || op == 5)) // nu au rost 2 interogari consecutive pentru aflarea min/max/card deoarece rezultatul ramane neschimbat
            op = rand() % 9 + 1;
        if(op == 1)
        {
            x = rand();
            while(x <= 1000000000 + rand())
                x = (x + rand() * 10000) % MAX;

            coada[++ marime] = x;
            F << op << " " << x << "\n";
        }
        else if(op == 2)
        {
            if(marime >= 1000)
            {
                aux = rand() % 6 + 1;     // [1,6]
                if(aux == 5)                   // 16.6% sanse sa stearga minimul
                {
                    F << op << " " << S.minn() << "\n";
                    continue;
                }
                if(aux == 6)                   // 16.6% sanse sa stearga maximul
                {
                    F << op << " " << S.maxx() << "\n";
                    continue;
                }
            }
            if(marime != 0)aux = rand() % marime + 1;
            else F << 1 << " " << rand() << "\n";
            x = coada[aux];
            F << op << " " << x << "\n";
        }
        else if(op == 9)
        {
            if(marime != 0)aux = rand() % marime + 1;
            else op = 1, aux = rand();
            x = aux;
            F << op << " " << x << "\n";
        }
        else if(op >= 6 && op <= 9)   // succ/pred/este_in/k_element
        {
            x = rand();
            while(x <= 1000000000 + rand())
                x = (x + rand() * 10000) % MAX;

            F << op << " " << x << "\n";
        }
        else F << op << "\n";
        prev_op = op;
    }
    */
    ifstream f("treap.in");
    ofstream g("treap.out");
    f >> q;
    for(i = 1; i <= q; i ++)
    {
        f >> op;
        if(op == 1)
        {
            f >> x;
            if(S.este_in(x) == 0)S.insert(x);       //daca se afla deja in treap nu il mai punem
        }
        if(op == 2)
        {
            f >> x;
            S.erase(x);
        }
        if(op == 3)
        {
            g << S.minn() << "\n";
        }
        if(op == 4)
        {
            g << S.maxx() << "\n";
        }
        if(op == 5)
        {
            g << S.cardinal() << "\n";
        }
        if(op == 6)
        {
            f >> x;
            g << S.este_in(x) << "\n";
        }
        if(op == 7)
        {
            f >> x;
            aux = S.succesor(x);
            if(aux == MAX)g << "Nu avem exista succesorul lui " << x << "\n";
            else g << aux << "\n";
        }
        if(op == 8)
        {
            f >> x;
            aux = S.predecesor(x);
            if(aux == MIN)g << "Nu avem exista predecesorul lui " << x << "\n";
            else g << aux << "\n";
        }
        if(op == 9)
        {
            f >> k;
            aux = S.k_element(k);
            if(aux == MIN)g << "Nu avem " << k << " elemente!\n";
            else g << aux << "\n";
        }
    }
    return 0;
}
