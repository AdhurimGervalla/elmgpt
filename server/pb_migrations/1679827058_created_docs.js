migrate((db) => {
  const collection = new Collection({
    "id": "1l6zs4yqndkdt70",
    "created": "2023-03-26 10:37:38.249Z",
    "updated": "2023-03-26 10:37:38.249Z",
    "name": "docs",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "n6uahlig",
        "name": "response",
        "type": "json",
        "required": false,
        "unique": false,
        "options": {}
      },
      {
        "system": false,
        "id": "lg3qc1dp",
        "name": "question",
        "type": "json",
        "required": false,
        "unique": true,
        "options": {}
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
  const collection = dao.findCollectionByNameOrId("1l6zs4yqndkdt70");

  return dao.deleteCollection(collection);
})
