migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1l6zs4yqndkdt70")

  // remove
  collection.schema.removeField("rvzp12dn")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "z0wguids",
    "name": "messages",
    "type": "json",
    "required": true,
    "unique": false,
    "options": {}
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1l6zs4yqndkdt70")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "rvzp12dn",
    "name": "category",
    "type": "relation",
    "required": false,
    "unique": false,
    "options": {
      "collectionId": "nybiwcgucsbs8ar",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": null,
      "displayFields": []
    }
  }))

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "z0wguids",
    "name": "messages",
    "type": "json",
    "required": true,
    "unique": true,
    "options": {}
  }))

  return dao.saveCollection(collection)
})
