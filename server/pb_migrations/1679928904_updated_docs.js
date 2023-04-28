migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1l6zs4yqndkdt70")

  // remove
  collection.schema.removeField("n6uahlig")

  // remove
  collection.schema.removeField("lg3qc1dp")

  // add
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
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1l6zs4yqndkdt70")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "n6uahlig",
    "name": "response",
    "type": "json",
    "required": false,
    "unique": false,
    "options": {}
  }))

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "lg3qc1dp",
    "name": "question",
    "type": "json",
    "required": false,
    "unique": true,
    "options": {}
  }))

  // remove
  collection.schema.removeField("z0wguids")

  return dao.saveCollection(collection)
})
