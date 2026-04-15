describe("Cart Feature", () => {
  it("adds product to cart", () => {
    cy.visit("http://localhost:3000")

    cy.contains("View Product").first().click()

    cy.contains("Add to Cart").click()

    cy.visit("http://localhost:3000/cart")

    cy.contains("Product")
  })
})