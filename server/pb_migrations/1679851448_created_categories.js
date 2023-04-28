migrate((db) => {
  const collection = new Collection({
    "id": "nybiwcgucsbs8ar",
    "created": "2023-03-26 17:24:08.714Z",
    "updated": "2023-03-26 17:24:08.714Z",
    "name": "categories",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "sjc2jh6v",
        "name": "name",
        "type": "text",
        "required": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      }
    ],
    "listRule": "",
    "viewRule": "",
    "createRule": "",
    "updateRule": "",
    "deleteRule": "",
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("nybiwcgucsbs8ar");

  return dao.deleteCollection(collection);
})
