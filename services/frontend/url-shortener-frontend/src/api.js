const backend_url = process.env.REACT_APP_BACKEND_URL
const getSlug = (url) => {
  return fetch(
    backend_url,
    {
      method: 'PUT',
      body: JSON.stringify({destination: url})
    }
  )
}

export { getSlug };
