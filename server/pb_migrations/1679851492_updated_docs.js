migrate((db) => {
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

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1l6zs4yqndkdt70")

  // remove
  collection.schema.removeField("rvzp12dn")

  return dao.saveCollection(collection)
})
