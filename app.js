import express from 'express'
import cors from 'cors'

import { getNotes, getNote, createNote, getProduct, getProductVariants } from './database.js'

const app = express()

app.use(cors())

app.get("/notes", async (req, res) => {
  const notes = await getNotes()
  res.send(notes)
})

app.get("/notes/:id", async (req, res) => {
  const id = req.params.id
  const note = await getNote(id)
  res.send(note)
})

app.post("/notes", async (req, res) => {
  const { title, contents } = req.body
  const note = await createNote(title, contents)
  res.status(201).send(note)
})

app.get("/product/:id", async (req, res) => {
  const id = req.params.id
  const note = await getProduct(id)
  res.send(note)
})

app.get("/productvariants/:id", async (req, res) => {
  const id = req.params.id
  const note = await getProductVariants(id)
  res.send(note)
})


app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).send('Something broke 💩')
})

app.listen(8080, () => {
  console.log('Server is running on port 8080')
})