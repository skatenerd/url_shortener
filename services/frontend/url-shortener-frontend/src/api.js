const backendUrl = process.env.REACT_APP_BACKEND_URL

const getSlug = (url) => {
  return fetch(
    backendUrl,
    {
      method: 'PUT',
      body: JSON.stringify({destination: url})
    }
  )
}

export { getSlug, backendUrl };
