migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1l6zs4yqndkdt70")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "kc9rym1x",
    "name": "scraped",
    "type": "bool",
    "required": false,
    "unique": false,
    "options": {}
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("1l6zs4yqndkdt70")

  // remove
  collection.schema.removeField("kc9rym1x")

  return dao.saveCollection(collection)
})
