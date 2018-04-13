package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 *
 * the JPA fields are decorated so that only some are exported
 * see MilkRunRestController "/route/get" for details
 */

import com.fasterxml.jackson.annotation.JsonView;
import com.mike.exceptions.InvalidAddressException;
import com.mike.util.Location;
import com.mike.util.Log;
import com.mike.util.Util;
import com.mike.website3.GoogleMappingInterface;
import com.mike.website3.MySystemState;
import com.mike.website3.RestApi.Views;
import com.mike.website3.Website;
import com.mike.website3.db.repo.AddressRepo;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by mike on 11/6/2016.
 */
@Entity
@Table(name="addresses")
public class Address implements Serializable {

    private static final long serialVersionUID = -8425812882578831369L;
    private static final String TAG = Address.class.getSimpleName();


    /**
     * various flavors of Address records for a user
     */
    static public enum Usage {
        Default,        // used for anything
    }

    @Id
    @Column(name = "id")                private String id;

    @JsonView(Views.Public.class)
    @Column(name = "users_id")          private String userId;

    @JsonView(Views.Public.class)
    @Column(name = "firstName")         private String firstName = "";

    @JsonView(Views.Public.class)
    @Column(name = "lastName")          private String lastName = "";

    @JsonView(Views.Public.class)
    @Column(name = "street")            private String street = "";

    @JsonView(Views.Public.class)
    @Column(name = "city")              private String city = "";

    @JsonView(Views.Public.class)
    @Column(name = "state")             private String state = "";

    @JsonView(Views.Public.class)
    @Column(name = "zip")               private String zip = "";

    @JsonView(Views.Public.class)
    @Column(name = "longitude")         private double longitude = 0;
    @JsonView(Views.Public.class)
    @Column(name = "latitude")          private double latitude = 0;

    @Column(name = "timestamp", columnDefinition = "timestamp without time zone DEFAULT timestamp 'now ( )'")
    private Timestamp timestamp = MySystemState.getInstance().nowTimestamp();

    @JsonView(Views.Public.class)
    @Enumerated(EnumType.STRING)
    private Usage usage = Usage.Default;

    @JsonView(Views.Public.class)
    @Column(name = "street2", columnDefinition = "text default ''")
    private String street2 = "";


    public String getId() {
        return id;
    }
    public String getFirstName() {
        return firstName;
    }
    public String getLastName() {
        return lastName;
    }
    public String getStreet() {
        return street;
    }
    public String getStreet2() {
        return street2;
    }
    public String getCity() {
        return city;
    }
    public String getState() {
        return state;
    }
    public String getZip() {
        return zip;
    }
    public String getUserId() {
        return userId;
    }
    public Usage getUsage() {
        return usage;
    }

    public String getUsageAsString() {
        // don't have FreeMarker and enums happy yet
        return usage.toString();
    }

    private void setId(String id) {
        this.id = id;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }
    public void setFirstName(String firstName) {
        this.firstName = Util.sanitizeForDB(firstName);
    }
    public void setLastName(String lastName) {
        this.lastName = Util.sanitizeForDB(lastName);
    }
    public void setStreet(String street) {
        this.street = Util.sanitizeForDB(street);
    }
    public void setStreet2(String street2) {
        this.street2 = Util.sanitizeForDB(street2);
    }
    public void setCity(String city) {
        this.city = Util.sanitizeForDB(city);
    }
    public void setState(String state) {
        this.state = Util.sanitizeForDB(state);
    }
    public void setZip(String zip) {
        this.zip = Util.sanitizeForDB(zip);
    }
    public void setUsage(Usage usage) {
        if (usage == null)
            this.usage = Usage.Default;
        this.usage = usage;
    }

    public double getLatitude() {
        return latitude;
    }
    public double getLongitude() {
        return longitude;
    }

    public Location getLocation() {
        return new Location(longitude, latitude);
    }

    public boolean hasValidGeoLocation() {
        // invalid address records have lat,lng of 0,0
        return (Math.abs(longitude) > 0.1) && (Math.abs(latitude) > 0.1);
    }

    protected Address() {
    }

    public void save() {
        getRepo().save(this);
    }
    public void delete() {
        getRepo().delete(this);
    }

    public Address(String userId) {
        setId(UUID.randomUUID().toString());
        setUserId(userId);
        setState(MySystemState.getInstance().getDefaultState());
        setUsage(Usage.Default);
    }
    public Address(String userId, Usage usage) {
        setId(UUID.randomUUID().toString());
        setUserId(userId);
        setState(MySystemState.getInstance().getDefaultState());
        setUsage(usage);
    }

    public void geoCodeAddress() throws InvalidAddressException {
        this.longitude = 0;
        this.latitude = 0;
        Location location = GoogleMappingInterface.geocode(this);
        this.longitude = location.x;
        this.latitude = location.y;
    }

    @Override
    public String toString() {
        String s = this.getId();
        if (s.length() < 8) {
            Log.e(TAG, "Bad address record ID");
            s = this.getId();
            if (s.length() < 1)
                s = "?";
        }
        else
            s = this.getId().substring(0,8);

        return String.format("%s... %s... %s %s, %s %s, %s %s",
                s,
                this.getUserId().length() > 8 ? getUserId().substring(0,8) : getUserId(),
                this.getFirstName(),
                this.getLastName(),
                this.getStreet(),
                this.getCity(),
                this.getState(),
                this.getZip());
    }
    public String toString(String companyName) {
        return String.format("%s %s %s, %s %s",
                companyName,
                this.getStreet(),
                this.getCity(),
                this.getState(),
                this.getZip());
    }

    public String getName() {
        String s = String.format("%s %s",
                this.getFirstName(),
                this.getLastName());
        if (s.length() == 0)
            s = String.format("%8.8s...", this.userId);
        return s;
    }

    public String getMailingAddress() {
        return String.format("%s %s %s, %s %s, %s %s",
                this.getFirstName(),
                this.getLastName(),
                this.getStreet(),
                this.getStreet2(),
                this.getCity(),
                this.getState(),
                this.getZip());
    }

    public String getStreetAddress(String companyName) {
        String s = companyName;
        if (s.length() == 0)
            s = getName();

        return String.format("%s %s %s %s, %s %s",
                s,
                this.getStreet(),
                this.getStreet2(),
                this.getCity(),
                this.getState(),
                this.getZip());
    }

    public boolean isValid() {
        return     (getName().length() > 3)
                && (getStreet().length() > 2)
                && (getCity().length() > 2);
    }


    static public AddressRepo getRepo() {
        return Website.getRepoOwner().getAddressRepo();
    }

    public static Address findById(String id) {
        return getRepo().findById(id);
    }


    public static Address findNewestByUserIdAndUsageS(String userId, String usage) {
        Address x = getRepo().findFirstByUserIdAndUsageOrderByTimestampDesc(userId, Usage.valueOf(usage));
        return x;
    }
    public static Address findNewestByUserIdAndUsage(String userId, Usage usage) {
        Address x = getRepo().findFirstByUserIdAndUsageOrderByTimestampDesc(userId, usage);
        return x;
    }

    public static List<Address> findNewestByUserId(String userId) {
        List<Address> x = new ArrayList<>();
        x.add(getRepo().findFirstByUserIdAndUsageOrderByTimestampDesc(userId, Usage.Default));
        return x;
    }

    public static List<Address> findAllByUserNameOrderByUsageDesc(String username) {
        return getRepo().findByUserIdOrderByUsageDesc(username);
    }

    public static List<Address> findByUserIdAndUsageOrderByUsageDesc(String userId, Usage usage) {
        List<Address> x = getRepo().findByUserIdAndUsageOrderByUsageDesc(userId, usage);
        return x;
    }

    public static Address findNewestByUserIdOrderByUsageDesc(String userId, Usage usage) {
        Address address = getRepo().findFirstByUserIdAndUsageOrderByTimestampDesc(userId, usage);
        return address;
    }
    public static List<Address> findNewestByUserIdOrderByUsageDesc(String userId) {
        List<Address> a = new ArrayList<>();
        a.add(getRepo().findFirstByUserIdAndUsageOrderByTimestampDesc(userId, Usage.Default));
        return a;
    }


    public String getUsername() {
        return userId;
    }

    public String getStreetAddress() {
        return String.format("%s %s %s, %s %s",
                this.getStreet(),
                this.getStreet2(),
                this.getCity(),
                this.getState(),
                this.getZip());
    }

    /** street address formatted for Google's geocode API */
    public String getGoogleStreetAddress() {
        return String.format("%s %s, %s %s",
                this.getStreet(),
//                this.getStreet2(),
                this.getCity(),
                this.getState(),
                this.getZip());
    }


    public String getName(Usage type) {
        return User.findByUsername(userId).getName(type);
    }


    public boolean same(Address address) {

        if (userId != null ? !userId.equals(address.userId) : address.userId != null) return false;
        if (firstName != null ? !firstName.equals(address.firstName) : address.firstName != null) return false;
        if (lastName != null ? !lastName.equals(address.lastName) : address.lastName != null) return false;
        if (street != null ? !street.equals(address.street) : address.street != null) return false;
        if (city != null ? !city.equals(address.city) : address.city != null) return false;
        if (state != null ? !state.equals(address.state) : address.state != null) return false;
        if (zip != null ? !zip.equals(address.zip) : address.zip != null) return false;
        if (usage != null ? !usage.equals(address.usage) : address.usage != null) return false;
        return street2 != null ? street2.equals(address.street2) : address.street2 == null;
    }

    //////// PlaceIntf

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Address address = (Address) o;

        if (id != null ? !id.equals(address.id) : address.id != null) return false;
        if (userId != null ? !userId.equals(address.userId) : address.userId != null) return false;
        if (firstName != null ? !firstName.equals(address.firstName) : address.firstName != null) return false;
        if (lastName != null ? !lastName.equals(address.lastName) : address.lastName != null) return false;
        if (street != null ? !street.equals(address.street) : address.street != null) return false;
        if (city != null ? !city.equals(address.city) : address.city != null) return false;
        if (state != null ? !state.equals(address.state) : address.state != null) return false;
        if (zip != null ? !zip.equals(address.zip) : address.zip != null) return false;
        if (usage != null ? !usage.equals(address.usage) : address.usage != null) return false;
        return street2 != null ? street2.equals(address.street2) : address.street2 == null;
    }

    @Override
    public int hashCode() {
        int result = id != null ? id.hashCode() : 0;
        result = 31 * result + (userId != null ? userId.hashCode() : 0);
        result = 31 * result + (firstName != null ? firstName.hashCode() : 0);
        result = 31 * result + (lastName != null ? lastName.hashCode() : 0);
        result = 31 * result + (street != null ? street.hashCode() : 0);
        result = 31 * result + (city != null ? city.hashCode() : 0);
        result = 31 * result + (state != null ? state.hashCode() : 0);
        result = 31 * result + (zip != null ? zip.hashCode() : 0);
        result = 31 * result + (usage != null ? usage.hashCode() : 0);
        result = 31 * result + (street2 != null ? street2.hashCode() : 0);
        return result;
    }

    public static void duplicate(Address a, Usage usage) {
        Address b = new Address(a.userId);
        b.usage = usage;
        b.setUserId(a.getUserId());
        b.setFirstName(a.getFirstName());
        b.setLastName(a.getLastName());
        b.setStreet(a.getStreet());
        b.setCity(a.getCity());
        b.setState(a.getState());
        b.setZip(a.getZip());
        b.longitude = a.longitude;
        b.latitude = a.latitude;
        b.save();
    }

}

