package dao;

import java.util.List;

import entities.Hotel;
import jakarta.ejb.Local;

@Local
public interface IDaoHotel extends IDaoLocale<Hotel> {
	 public List<Hotel> findHotelsByVille(int villeId);
}
