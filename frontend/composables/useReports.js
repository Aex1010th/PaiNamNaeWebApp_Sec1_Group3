export const useReports = () => {
  return useState('reports', () => {
    if (process.client) {
      return JSON.parse(localStorage.getItem('reports') || '[]')
    }
    return []
  })
}