package controllers;

import jakarta.ejb.EJB;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import dao.IDaoHotel;
import dao.IDaoVille;
import entities.Hotel;
import entities.Ville;

/**
 * Servlet implementation class HotelController
 */
public class HotelController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	@EJB
	private IDaoVille daoV;
	@EJB
	private IDaoHotel daoH;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public HotelController() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Retrieve parameters for hotel attributes
		String op = request.getParameter("op");
		if (op != null) {
			if (op.equals("Ajouter")) {
				String nom = request.getParameter("nom");
				String adresse = request.getParameter("adresse");
				String telephone = request.getParameter("telephone");

				// Retrieve the villeId from the request parameter
				String villeId = request.getParameter("villeId");

				if (villeId != null) {
					Ville ville = daoV.findById(Integer.parseInt(villeId));

					daoH.create(new Hotel(nom, adresse, telephone, ville));

				} else {
					Ville ville = null;
					daoH.create(new Hotel(nom, adresse, telephone, ville));

				}
				List<Hotel> hotels = daoH.findAll();
				List<Ville> villes = daoV.findAll();
				// Set the list of hotels as an attribute for the JSP
				request.setAttribute("hotels", hotels);
				request.setAttribute("villes", villes);
				System.out.println(villes);
				// Forward the request to the hotel.jsp page
				RequestDispatcher dispatcher = request.getRequestDispatcher("hotel.jsp");
				dispatcher.forward(request, response);
				

			} else if (request.getParameter("op").equals("delete")) {
				int id = Integer.parseInt(request.getParameter("id"));
				daoH.delete(daoH.findById(id));
				List<Hotel> hotels = daoH.findAll();
				List<Ville> villes = daoV.findAll();
				// Set the list of hotels as an attribute for the JSP
				request.setAttribute("hotels", hotels);
				request.setAttribute("villes", villes);
				System.out.println(villes);
				// Forward the request to the hotel.jsp page
				RequestDispatcher dispatcher = request.getRequestDispatcher("hotel.jsp");
				dispatcher.forward(request, response);
			} else if (request.getParameter("op").equals("update")) {
				try {
					int id = Integer.parseInt(request.getParameter("id"));
					String nom = request.getParameter("nom");
					String adresse = request.getParameter("adresse");
					String telephone = request.getParameter("telephone");
					String villeId = request.getParameter("villeId");
					Ville ville = daoV.findById(Integer.parseInt(villeId));

					// Create the updated object
					Hotel updatedHotel = new Hotel(nom, adresse, telephone, ville);
					updatedHotel.setId(id);

					// Perform the update operation
					Hotel result = daoH.update(updatedHotel);

					// Log information after the update
					System.out.println("Update successful - Updated Hotel: " + result);
					List<Hotel> hotels = daoH.findAll();
					List<Ville> villes = daoV.findAll();
					// Set the list of hotels as an attribute for the JSP
					request.setAttribute("hotels", hotels);
					request.setAttribute("villes", villes);
					System.out.println(villes);
					// Forward the request to the hotel.jsp page
					RequestDispatcher dispatcher = request.getRequestDispatcher("hotel.jsp");
					dispatcher.forward(request, response);
				} catch (Exception e) {
					e.printStackTrace(); // Handle the exception appropriately, log it, or send a response to the
											// client.
				}
			}
		} else {
            List<Hotel> hotels;
            List<Ville> villes = daoV.findAll();

            String filterVilleId = request.getParameter("filterVilleId");

            if (filterVilleId != null && !filterVilleId.isEmpty()) {
                int villeId = Integer.parseInt(filterVilleId);
                hotels = daoH.findHotelsByVille(villeId);
            } else {
                hotels = daoH.findAll();
            }

            request.setAttribute("hotels", hotels);
            request.setAttribute("villes", villes);
            RequestDispatcher dispatcher = request.getRequestDispatcher("hotel.jsp");
            dispatcher.forward(request, response);
        }
		List<Hotel> hotels = daoH.findAll();
		List<Ville> villes = daoV.findAll();
		request.setAttribute("hotels", hotels);
		request.setAttribute("villes", villes);
		RequestDispatcher dispatcher = request.getRequestDispatcher("hotel.jsp");
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