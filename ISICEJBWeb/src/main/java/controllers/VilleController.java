package controllers;

import jakarta.ejb.EJB;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import dao.IDaoLocale;
import entities.Ville;

/**
 * Servlet implementation class VilleController
 */
public class VilleController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@EJB
	private IDaoLocale<Ville> ejb;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public VilleController() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String op = request.getParameter("op");
		if (op != null) {
			if (op.equals("Ajouter")) {
				String nom = request.getParameter("ville");
				ejb.create(new Ville(nom));

			} else if (op.equals("delete")) {
				int id = Integer.parseInt(request.getParameter("id"));
				ejb.delete(ejb.findById(id));
			} else if (op.equals("update")) {
				try {
					int id = Integer.parseInt(request.getParameter("id"));
					String nom = request.getParameter("nom");

					// Check if ID is valid
					if (id <= 0) {
						throw new IllegalArgumentException("Invalid ID provided for the update operation");
					}

					// Check if nom is not empty
					if (nom == null || nom.trim().isEmpty()) {
						throw new IllegalArgumentException("Nom cannot be empty for the update operation");
					}

					// Log information about the update request
					System.out.println("Received update request - ID: " + id + ", Nom: " + nom);

					// Create the updatedVille object
					Ville updatedVille = new Ville(nom);
					updatedVille.setId(id);

					// Perform the update operation
					Ville result = ejb.update(updatedVille);


				} catch (Exception e) {
					e.printStackTrace(); // Handle the exception appropriately, log it, or send a response to the
											// client.
				}
			} if ("getCities".equals(op)) {
		        // Set the response content type to HTML
		        response.setContentType("text/html");

		        // Forward to the cityList.jsp to generate the HTML for cities
		        RequestDispatcher dispatcher = request.getRequestDispatcher("cityList.jsp");
		        dispatcher.forward(request, response);
		    }
        } else {
         
           
        }
		 List<Ville> villes = ejb.findAll();
         request.setAttribute("villes", villes);

         RequestDispatcher dispatcher = request.getRequestDispatcher("ville.jsp");
         dispatcher.forward(request, response);
		}
		
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}