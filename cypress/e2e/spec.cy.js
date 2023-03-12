describe('Home page', () => {
  it('Is the articles index page', () => {
    cy.visit('/')

    cy.contains('Articles')
  })
})

