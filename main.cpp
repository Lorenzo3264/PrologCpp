
#include "SWI-cpp2.h"
#include <string>
#include <iostream>
#include <vector>

using namespace std;

void openPrologFile(const char* name) {
    try {
        PlCall("consult", PlTermv(PlAtom(name)));
    }
    catch (const PlException& err) {
        cerr << "couldn't open prolog file... error: " << err.what();
    }
}

void makePrologList(vector<string> list, PlTerm term) {
    PlTerm_tail tail(term); //tail of the prolog list
    try {
        for (auto &elem : list) {
            PlTerm temp(PlTerm(PlAtom(elem.c_str())));
            if (!tail.append(temp)) {
                cerr << "couldn't add atom to list...";
                break;
            }
        }
        if (!tail.close()) cerr << "couldn't unify tail of list with []...";
    }
    catch (const PlException& err) {
        cerr << "couldn't create prolog list... error: " << err.what();
    }
}

int initializeProlog(int argc, char** argv) {
    if (_putenv("SWI_HOME_DIR=C:\\Program Files\\swipl")) return 0;
    if (!PL_initialise(argc, argv))
        PL_halt(1);
    return 1;
}

int performQuery(const char* rule, PlTermv arguments, vector<PlTermv> myOutput) {
    //l'output dipende da come la regola e' stata definita
    //genenro un vettore di risposte, cosi' ovunque si trovi l'output dovrebbe essere reperibile.
    PlQuery query(rule, arguments);
    try {
        while (query.next_solution()) {
            myOutput.push_back(PlTermv(arguments));
        }
    }
    catch (const PlException& e) {
        cerr << "couldn't perform query... error: " << e.what();
    }
    
    return myOutput.size();
}

int performQuery(const char* plModule, const char* rule, PlTermv arguments, vector<PlTermv> myOutput) {
    //l'output dipende da come la regola e' stata definita
    //genero un vettore di risposte, cosi' ovunque si trovi l'output dovrebbe essere reperibile.
    PlQuery query(plModule, rule, arguments);
    
    try {
        while (query.next_solution()) {
            PlTermv temp(arguments);
            myOutput.push_back(temp);    
            cout << temp[0].as_string() << "\n";
        }
        
    }
    catch (const PlException& e) {
        cerr << "couldn't perform query... error: " << e.what();
    }
    cout << "size: " << myOutput.size() << "\n";
    return myOutput.size();
}

int assertRule(const char* ruleName, PlTermv terms) {
    PlQuery query("assert", PlTermv(PlCompound(ruleName, terms)));
    return query.next_solution();
}


int main(int argc, char** argv)
{
    if(!initializeProlog(argc, argv)) return 0;

    openPrologFile("bigProject");
    vector<string> phrase({ "the","woman","likes","the","man" });
    PlTermv av(1);
    vector<PlTermv> myOutputs;

    //makePrologList(phrase, av[1]);
    
    cout << "result: " << assertRule("white", PlTermv(PlAtom("chocolate"))) << "\n";
    
    cout << "result: " << assertRule("white", PlTermv(PlAtom("paper"))) << "\n";
    
    PlQuery q("white", av);
    q.next_solution();
    cout << "out: " << av[0].as_string() << "\n";
    q.next_solution();
    cout << "out: " << av[0].as_string() << "\n";

    PlTermv arrayv(2);
    makePrologList(phrase, arrayv[1]);
    
    PlQuery query("smallProject", "main", arrayv);
    try {
        PlCheckFail(query.next_solution());
    }
    catch (PlException e) {
        cerr << "out: " << e.what() << "\n";
    }
    catch (PlFail f) {
        cerr << "query fallita :(\n";
    }
    
    cout << "out: " << arrayv[0].as_string() << "\n";
    /*for (PlTermv& elem : myOutputs) {
        cout << "out: " << elem[0].as_string() << "\n";
    }*/

    //PL_halt(PL_toplevel() ? 0 : 1);
}