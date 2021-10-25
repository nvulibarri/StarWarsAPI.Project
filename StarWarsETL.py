import requests
import pyodbc


def request():
    StarWarsConnection = pyodbc.connect("CONNECTION STRING")
    i = 1
    base_url = 'https://swapi.dev/api/people/'
    while i in range(1, 83):
        url = base_url + str(i)
        # print(url)
        req = requests.get(url)
        r = req.json()
        # print(r)
        # print(type(r))
        # for key, value in r.items():  # printing key and value items in list for each json dict requested
        #    print(key, value)
        crsr = StarWarsConnection.cursor()
        crsr.execute('INSERT INTO StarWarsJson(ID, Json_Data) values (?,?)', i, str(r))
        crsr.commit()
        crsr.close()
        i = i + 1

    StarWarsConnection.close()


request()
