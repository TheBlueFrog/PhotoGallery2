package com.mike.website3.db;

/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.txt', which is part of this source code package.
 */

import com.mike.website3.Website;
import com.mike.website3.db.repo.EmailAddressRepo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.List;
import java.util.UUID;

/**
 * Created by mike on 11/6/2016.
 */
@Entity
@Table(name="user_emails")
public class EmailAddress implements Serializable {

    private static final String table = "user_emails";

    private static final long serialVersionUID = -636450336582158225L;

    // are not the only users of this db so make ourself aware of the
    // sequence number machinery in the db
    // this kind of incantation seems to work...

//    @Id
//    @GeneratedValue(strategy= GenerationType.SEQUENCE, generator="user_emails_gen")
//    @SequenceGenerator(name="user_emails_gen",sequenceName="user_emails_id_seq",allocationSize=1)
//    private int id;

    @Id
    @Column(name = "id")                        private String id;

    @Column(name = "users_id")                  private String userId;
    @Column(name = "email")                     private String email = "";

    public String getId() { return id; }
    public String getUserId() { return userId; }
    public String getEmail() {
        return email;
    }

    private void setUserId(String userId) {
        this.userId = userId;
    }
    public void setEmail(String email) {
        this.email = email.replace("'", "");
    }

    protected EmailAddress() { }

    public EmailAddress(User user, String email) {
        id = UUID.randomUUID().toString();
        setUserId(user.getUsername());
        setEmail(email);
    }

//    public EmailAddress(User user, JSONObject j) {
//        id = j.has("id") ? j.getString("id") : UUID.randomUUID().toString();
//
//        userId = j.has("user_id") ? j.getString("user_id") : user.getUsername();
//        assert user.getUsername().equals(userId);
//
//        email = j.getString("email");
//    }
//
//    public JSONObject toJSON() {
//        JSONObject j = new JSONObject();
//        j.put("id", id);
//        j.put("user_id", userId);
//        j.put("email", email);
//        return j;
//    }

    @Override
    public String toString() {
        return String.format("%s",
                this.getId().substring(0, 8),
                this.getEmail());
    }

    public void save() {
        getRepo().save(this);
    }
    public void delete() {
        getRepo().delete(this);
    }

    private static EmailAddressRepo getRepo() {
        return Website.getRepoOwner().getUserEmailRepo();
    }

    public static List<EmailAddress> findByUserId(String username) {
        List<EmailAddress> x = getRepo().findByUserId(username);
        return x;
    }

    public static EmailAddress findById(String id) {
        EmailAddress x = getRepo().findById(id);
        return x;
    }

    public static List<EmailAddress> findByEmail(String email) {
        List<EmailAddress> x = getRepo().findByEmail(email);
        return x;
    }

    public static List<EmailAddress> findAll() {
        List<EmailAddress> x = (List<EmailAddress>) getRepo().findAll();
        return x;
    }
}


/*

'120df62e-4e8f-4c1b-bbcc-d3e75df871e5',       'Rebecca.Hagmuller@gmail.com',       'Rebecca_Hagmuller                   '                    Hagmuller,Rebecca,
'734ec0cc-8eed-4538-87bd-66249ac60816',       'Max517@gmail.com           ',       'Max_Ginsburg                        '                    Ginsberg,Max,
'434c2084-1463-4847-b034-b58eed21b5f3',       'Lindajoy2001@hotmail.com   ',       'Linda_Joy                           '                    Joy,Linda,
'74ad7b03-011f-4ec5-b41b-067ec5f3d144',       'nicole.lendo@gmail.com     ',       'Nicole_Lendo                        '                    Lendo,Nicki,
'abf9df59-ae19-4023-9c32-024af2db53e2',       'vanessa.margolis@gmail.com ',       'Vanessa_Margolis                    '                    Margolis,Vanessa,
'e3e7760c-4a58-495d-9547-6bfdce1c645c',       'jon@oregonangelfund.com    ',       'Jon_Maroney                         '                    Maroney,Jon,
'cd7b5188-7ef7-11e7-bb31-be2e44b06b34',       'amy.maroney@gmail.com      ',       'Amy_Maroney                         '                    Maroney,Amy,
'cd7b587c-7ef7-11e7-bb31-be2e44b06b34',       'trish.m.cannon@gmail.com   ',       'Trish_Cannon                        '                    Cannon,Trish,
'cd7b5ade-7ef7-11e7-bb31-be2e44b06b34',       'scott@scottwerley.com      ',       'Scott_Werley                        '                    Werley,Scott,
'cd7b5ce6-7ef7-11e7-bb31-be2e44b06b34',       'kajaglickenhaus@yahoo.com  ',       'Kaja_Taft                           '                    Taft,Kaja,
'cd7b5eda-7ef7-11e7-bb31-be2e44b06b34',       'windsormeyer@gmail.com     ',       '6b2fde44-25fc-4849-9ddc-ea2e68d7c9b0'                    Meyer,Windsor,
'cd7b60e2-7ef7-11e7-bb31-be2e44b06b34',       'pdxcsk@gmail.com           ',       'Tressa_Yellig                       '                    Yellig,Tressa,
'cd7b6632-7ef7-11e7-bb31-be2e44b06b34',       'K8rouse@gmail.com          ',       'Kate_DuHadway                       '                    DuHadway,Kate,
'cd7b684e-7ef7-11e7-bb31-be2e44b06b34',       'daniellbliss@gmail.com     ',       'Bliss_Nut_Butters                   '                    Bliss,Daniell,
'cd7b6a2e-7ef7-11e7-bb31-be2e44b06b34',       'ollie17@gmail.com          ',       'Alia_DiOrio                         '                    DiOrio,Alia,
'cd7b6ca4-7ef7-11e7-bb31-be2e44b06b34',       'liz.turner@gmail.com       ',       'Liz_Turner                          '                    Turner,Liz,
'cd7b70a0-7ef7-11e7-bb31-be2e44b06b34',       'margaretckendall@me.com    ',       '5c694598-8e9d-463a-bfcf-f0a25454c888'                    Alvarez,Margaret,
'cd7b7816-7ef7-11e7-bb31-be2e44b06b34',       'stellamacaroni@gmail.com   ',       '46635cd2-1e63-4bd7-8782-efe407225513'                    Mooney,Sarah,
'cd7b7b2c-7ef7-11e7-bb31-be2e44b06b34',       'gregorymc@gmail.com        ',       '45456ca3-fc63-4825-a195-553bf68d282d'                    McManis,Gregory,
'cd7b7dfc-7ef7-11e7-bb31-be2e44b06b34',       'Madelinetomseth@gmail.com  ',       '0dfd9270-8606-486b-9597-a8d970a27e59'                    Tomseth,Madeline,
'cd7b80c2-7ef7-11e7-bb31-be2e44b06b34',       'schneik80@gmail.com        ',       'f1ba0812-c60e-4787-b187-20650afbf90f'                    Schneider,Kevin,
'cd7b82ca-7ef7-11e7-bb31-be2e44b06b34',       'kingram10@gmail.com        ',       '8ad56b18-b54f-477c-a1af-788bf8d067c1'                    Ingram,McKenzie,
'cd7b8874-7ef7-11e7-bb31-be2e44b06b34',       'semaphoria@gmail.com       ',       'fac90bfb-3d44-4340-a336-8e57bd2434ee'                    Keller,James,
'                                    '        '                                  '


Comerford,Thubten,thubten@wepostmedia.com


NEW (not in database),,
Almaraz,Teddy,teddya26@yahoo.com
Swan,Jess,swaja17@gmail.com




insert into user_emails (id,email,users_id) values ('120df62e-4e8f-4c1b-bbcc-d3e75df871e5','Rebecca.Hagmuller@gmail.com','Rebecca_Hagmuller');
insert into user_emails (id,email,users_id) values ('734ec0cc-8eed-4538-87bd-66249ac60816','Max517@gmail.com','Max_Ginsburg');
insert into user_emails (id,email,users_id) values ('434c2084-1463-4847-b034-b58eed21b5f3','Lindajoy2001@hotmail.com','Linda_Joy');
insert into user_emails (id,email,users_id) values ('74ad7b03-011f-4ec5-b41b-067ec5f3d144','nicole.lendo@gmail.com','Nicole_Lendo');
insert into user_emails (id,email,users_id) values ('abf9df59-ae19-4023-9c32-024af2db53e2','vanessa.margolis@gmail.com','Vanessa_Margolis');
insert into user_emails (id,email,users_id) values ('e3e7760c-4a58-495d-9547-6bfdce1c645c','jon@oregonangelfund.com','Jon_Maroney');
insert into user_emails (id,email,users_id) values ('cd7b5188-7ef7-11e7-bb31-be2e44b06b34','amy.maroney@gmail.com','Amy_Maroney');
insert into user_emails (id,email,users_id) values ('cd7b587c-7ef7-11e7-bb31-be2e44b06b34','trish.m.cannon@gmail.com','Trish_Cannon');
insert into user_emails (id,email,users_id) values ('cd7b5ade-7ef7-11e7-bb31-be2e44b06b34','scott@scottwerley.com','Scott_Werley');
insert into user_emails (id,email,users_id) values ('cd7b5ce6-7ef7-11e7-bb31-be2e44b06b34','kajaglickenhaus@yahoo.com','Kaja_Taft');
insert into user_emails (id,email,users_id) values ('cd7b5eda-7ef7-11e7-bb31-be2e44b06b34','windsormeyer@gmail.com','6b2fde44-25fc-4849-9ddc-ea2e68d7c9b0');
insert into user_emails (id,email,users_id) values ('cd7b6632-7ef7-11e7-bb31-be2e44b06b34','K8rouse@gmail.com','Kate_DuHadway');
insert into user_emails (id,email,users_id) values ('cd7b6a2e-7ef7-11e7-bb31-be2e44b06b34','ollie17@gmail.com','Alia_DiOrio');
insert into user_emails (id,email,users_id) values ('cd7b6ca4-7ef7-11e7-bb31-be2e44b06b34','liz.turner@gmail.com','Liz_Turner');
insert into user_emails (id,email,users_id) values ('cd7b7816-7ef7-11e7-bb31-be2e44b06b34','stellamacaroni@gmail.com','46635cd2-1e63-4bd7-8782-efe407225513');
insert into user_emails (id,email,users_id) values ('cd7b7b2c-7ef7-11e7-bb31-be2e44b06b34','gregorymc@gmail.com','45456ca3-fc63-4825-a195-553bf68d282d');
insert into user_emails (id,email,users_id) values ('cd7b7dfc-7ef7-11e7-bb31-be2e44b06b34','Madelinetomseth@gmail.com','0dfd9270-8606-486b-9597-a8d970a27e59');
insert into user_emails (id,email,users_id) values ('cd7b80c2-7ef7-11e7-bb31-be2e44b06b34','schneik80@gmail.com','f1ba0812-c60e-4787-b187-20650afbf90f');
insert into user_emails (id,email,users_id) values ('cd7b82ca-7ef7-11e7-bb31-be2e44b06b34','kingram10@gmail.com','8ad56b18-b54f-477c-a1af-788bf8d067c1');
insert into user_emails (id,email,users_id) values ('cd7b8874-7ef7-11e7-bb31-be2e44b06b34','semaphoria@gmail.com','fac90bfb-3d44-4340-a336-8e57bd2434ee');

insert into user_emails (id,email,users_id) values ('77a1108a-cca5-45c8-84c5-4f013d705df9','lamo0654@pacificu.edu','Dana_LaMonica ');


not needed
insert into user_emails (id,email,users_id) values ('cd7b684e-7ef7-11e7-bb31-be2e44b06b34','daniellbliss@gmail.com','Bliss_Nut_Butters');
insert into user_emails (id,email,users_id) values ('cd7b60e2-7ef7-11e7-bb31-be2e44b06b34','pdxcsk@gmail.com','Tressa_Yellig');
insert into user_emails (id,email,users_id) values ('cd7b70a0-7ef7-11e7-bb31-be2e44b06b34','margaretckendall@me.com','5c694598-8e9d-463a-bfcf-f0a25454c888');










cd7b8874-7ef7-11e7-bb31-be2e44b06b34
cd7b8bd0-7ef7-11e7-bb31-be2e44b06b34
cd7b8de2-7ef7-11e7-bb31-be2e44b06b34
cd7b8fc2-7ef7-11e7-bb31-be2e44b06b34


--------dump of all emails

 63937907-8e95-48e2-a4da-8c687db6d0f1 |                                | 16c7bead-e3e1-44b8-ba9b-b26010c45a37
 ef543412-d431-4678-8ce7-758f277e3ad2 | abby.rutschman@gmail.com       | 67b67dca-bd7e-4345-acc6-eaeca67468c3
 d31e7def-be98-4a00-b111-15a2383ff754 | aboutard@easystreet.net        | Ayers_Creek_Farm
 c5ae7d09-02ee-4aa6-90fc-d40633355831 | amberdaggett@gmail.com         | 2c896b6d-03f1-4d9d-9d0f-3f05b845eaf3
 056528bd-4c7d-463d-8c3a-d4f1d4653650 | amilindsey@comcast.net         | 8f819738-47d5-46cb-9f1c-75f812c65571
 fe135314-5dc3-4a8e-8473-161ad0c8ee1a | amye@msamye.com                | 7f5d4f1d-c29e-4cf0-ad1f-1686e1350667
 c599c31c-8fd6-4b68-936c-8dd5a80b4dbc | Amy.hillman@gmail.com          | 672aa42b-856e-4875-ab73-edff924fa52b
 cd7b5188-7ef7-11e7-bb31-be2e44b06b34 | amy.maroney@gmail.com          | Amy_Maroney
 0650f0c6-72e9-44cb-bddf-78d6827598c0 | asa@tinycreative.com           | dfdac766-4033-42ac-863a-fd238f0e95ab
 f8bf60cc-f991-443a-90f1-dce63ec8a91f | Avfodor@gmail.com              | f90c1c4c-37b9-4d84-abea-131736715bdc
 c5e2f64a-4c2f-45b1-8214-7c9e865745f1 | bairdfamilyorchards@gmail.com  | fb4cced2-4f8f-4699-8fcc-081f5ad9e1a0
 accb3174-ab55-4157-a971-69a03233a8ae | barb@barbmeyer.net             | 28947630-3c57-4cb5-8995-16658aebc224
 bc600054-5ea3-40f1-a8a0-df75f7511679 | Barnypok                       | 3b80fc26-b289-4795-aa01-b5f3d7331491
 a931ede5-4456-4857-8142-376a48ce4fab | bartlett.jax@gmail.com         | Jackie_Bartlett
 a03213da-bc5b-4076-902b-f37c406d63e4 | ben@revelmeatco.com            | e89438d8-1db0-4872-b9b0-e52d801496fd
 61f6f0d4-f9a4-450a-938e-58294477c0e1 | bolgioni@gmail.com             | Dawn_Bolgioni
 71f1aeec-ba8b-44e2-9f8e-98168a1fac98 | brunch@trinketpdx.com          | 5582e081-3fe5-4e30-877d-080fee812c3f
 82ab1391-3875-4c76-bfd7-b260d375d563 | cakewalkbaking@aol.com         | e1ccb5b4-f4d8-42a4-96fc-1a3649f14743
 f0e44fcc-6c49-4022-9dbf-9b72b2d13504 | caroline@bergstromwines.com    | 6cf6da15-4749-4519-902d-abdc2bf2fcaf
 19b926f9-eb2f-482c-a7e9-a9191aae10e5 | carrieyoung@comcast.net        | Carrie_Young
 8cdea51b-ec13-4c3e-8fc8-e89066d9cf82 | Chadledson@icloud.com          | 7f9caf1d-ea35-4461-809b-5bd1e058db6c
 f0ebc016-85e4-4840-ad6b-d2cc4d4280eb | chamborres@gmail.com           | 423c1598-b086-4728-9ec1-e8ce429b1be3
 84ebc5ea-f7ae-4de6-ae5a-16f537493957 | charface01@gmail.com           | db9eb48c-d8dc-44a0-85c6-aa69aa1f7786
 ab07f967-7459-4ca2-b23a-f88bfa0fd99c | chris@gmail.com                | 86c2968d-4e05-48a2-8c4c-66f3c7333497
 1c6ed194-7874-494e-8b15-4cdebd74fc89 | chrisserlin@gmail.com          | a085976c-a781-4dac-a894-ef814699fcf5
 2d800d28-39fc-4d03-9b05-9807b749c496 | Christine@maynardmail.com      | 78aadf6d-36be-4ea9-b0b6-c76cd4a996de
 dacf2ebd-76ad-42d0-bc71-8a3ba998a189 | chris.wilhite@gmail.com        | 79331220-0724-4402-a350-eac52f0139c4
 d218bb06-f2d5-4b5c-a18c-05610dcdbd0b | cody@cascadeorganic.com        | 7998b629-bbb2-4a3a-8b28-6095ee1edbae
 d7b85452-2264-4e7c-aff6-f6c8a8424dd7 | Colonel_korn@hotmail.com       | ac3b18ab-0a76-47d5-8b41-d5772a113143
 f40374a1-9d06-4ebb-b1a0-361d05e0128f | connor.martin@gmail.com        | Connor_Martin
 3d3b68aa-a44a-4b6c-b929-dfce39748585 | Courtdavies@yahoo.com          | Courtney_Davies
 d39404ba-4eff-475c-8794-5f2c6dc1ed7b | cristen@livingroomre.com       | 105255be-1229-4c8f-82a2-cf6197d38206
 80bc8570-cdd9-44af-ba7e-a03096e86d0b | daniellbliss@gmail.com         | Bliss_Nut_Butters
 ae3b48d5-be73-41f7-a3b7-88d20b36a8fc | danielleashleygeorge@gmail.com | d2cdbb20-9319-42fb-9c71-de699f5a6cec
 cb13b131-0221-4814-9018-985385e9cdf1 | danielle.hubbard12@gmail.com   | Danielle_Hubbard
 e6cde484-b022-463b-bacf-ebcfb8f8b98d | denoblefarms@gmail.com         | 5517eead-b8e7-4207-b36d-8eaecae49dea
 f625cf17-ed55-4ed1-94b1-66abad64179f | detrusley@yahoo.com            | Deidra_Trusley
 c56f955d-83ac-4feb-b928-72ce06bf7060 | dkambury@mac.com               | 68d7e45c-4453-4646-97e7-04e32829cac5
 7bf8cd0f-6cfa-45d3-9093-59f5e363a49c | dsmcgraw18@gmail.com           | 320536f1-ce99-4697-af77-2ff04d5d5c8e

 2298aa69-acbb-457c-aebb-5b11be32e026 | eaters@localmilkrun.com        | 8cd2102c-0c4a-422c-8a8f-1edccbdc0cc3
 c485bc8a-50f2-4c47-9834-ae31c3c42621 | eaters@localmilkrun.com        | 2dc94634-f7d7-4a8e-9443-1876df228074
 892cc503-2341-4201-ade7-411d48a2253f | eaters@localmilkrun.com        | Chef_Kit

 3b293c35-5096-419a-80f6-f61290fcad5a | efschnei@yahoo.com             | 4cedff25-fe24-4a02-beff-cf0d0e93f2c3
 eec1de11-5f07-4014-9e13-45cd492c135e | emery.stephen@gmail.com        | a434151e-cc7e-40f5-8c56-54e281248810
 d22be76f-f485-4b5a-a3b4-f3141f4e9dd0 | fitforexcellence@live.com      | 99f6a3b0-ca54-4d83-9015-082218f18124
 0a7f907a-3457-4f8b-944b-1cc8e1a72bf5 | five3four@gmail.com            | Ben_Jenkins
 6429add3-d034-46bc-933f-efd1280c1e2c | foreman.karen@gmail.com        | Karen_Foreman
 45ebbb6e-872b-4e92-abd8-9963d2ba3d98 | giddyuproanie1@gmail.com       | 3a34a141-6cbf-43bf-b355-10118deaae08
 6564c052-cbe6-4180-8a58-58eb3e79e57c | gregorymc@gmail.com            | 45456ca3-fc63-4825-a195-553bf68d282d
 c6189a6c-a885-4f9e-8687-e81b31a2d969 | grunkdoc@yahoo.com             | 0dfac06e-bc26-45a1-aec7-3460f6ffa5f5
 75c7af94-3a06-4f13-9b98-322fce630f0b | gtf@gatheringtogetherfarm.com  | d282ef0e-aec4-4f78-b890-af95c5e4ef84
 030214bf-eaca-43ca-b1bd-7a3f4073fd5b | hbwarman@gmail.com             | e9d2859b-f75f-4d6d-9528-fa8324edb6d0
 ac501a13-880b-49b0-b69f-2d419782f316 | heatherk@stumptowncoffee.com   | Stumptown_Coffee
 6b70c691-9676-465b-a426-8c018e6c11f0 | Heather@thorfarmsalpacas.com   | 22d0e6a0-bf4a-473f-b828-eed97166b935
 9f9e5067-de4a-46ea-a4e3-6760dc490b4e | hoffman.mindy@gmail.com        | b13529cb-c616-467d-8439-e3e0626fbdf0
 1a332857-f269-44e8-9aec-aa6b632a51a4 | info@betahatch.com             | 297b7c6e-741b-4fc1-b69c-d45cee368537
 142333e3-d2c0-496f-ae37-9a56ea092d1b | info@coquinepdx.com            | Coquine
 f927b200-8c26-4435-9a0b-465571a448bb | info@ecodistricts.org          | f951e871-bd0a-48ca-9c0a-188863c7e9ae
 2398f101-b004-4e3c-b082-1eee016c4e5b | jacobscreamery@gmail.com       | 5eff1a92-cfcc-40ae-8a5e-b40893d09e37
 32d8d30a-9df0-4645-b899-2476eb917f6e | james@revelmeatco.com          | Lardo
 cfaa5dfe-d7fa-44d0-a314-36b09b370074 | jamie.le.ha@gmail.com          | jle808
 6563555c-9552-4ed0-9d38-c8d126987d32 | jen.bryman.76@gmail.com        | 0bdec980-621d-4e5b-b266-1d4d2aadae07
 9c64faab-f277-4f0c-b689-a02bd6a0be6b | jen@ourtable.us                | Our_Table_Cooperative
 b6e3c4b8-a6c2-43ce-92a0-44c06c26ee6e | jessica@woodblockchocolate.com | Jessica_Wheelock
 681d9cf2-ffe5-477c-95cd-0b3e7d77a31c | jevons@gmail.com               | 1ff6e8a9-5796-46b0-9871-970d01a71af0
 e1eb8afd-e4de-436c-b007-5caa9a6b6304 | jgserlin@gmail.com             | James_Serlin
 5a56aebf-3950-4a5d-a9b2-ff94c21c5d6a | jnhusker@mac.com               | a4d6cc31-a78a-4ba4-a6e3-b07a9e9bd55b
 9cf14a3d-65af-4d97-815f-441eeb234e33 | jodieo10@mac.com               | 081fbbb9-b4df-4997-89e8-2e2ddecd1ae0
 6eea84ee-f81f-4cae-9b16-6f2d6a2897ec | johanna.blackford@gmail.com    | Johanna_Blackford
 e3e7760c-4a58-495d-9547-6bfdce1c645c | jon@oregonangelfund.com        | Jon_Maroney
 d5962dfe-bd23-4f58-b1ee-fd5716e3bce8 | k8rouse@gmail.com              | Kate_DuHadway
 706136dc-078b-478f-9b5e-824767275aba | kajaglickenhaus@yahoo.com      | Kaja_Taft
 26485c3f-b488-4f1f-84aa-e2976ccea475 | karise@gmail.com               | Magen_Gulliford
 92251924-81cc-4fb1-b937-1533ae481103 | kathleen@kathleenbauer.com     | Kathleen_Bauer
 bf148b0c-4d98-4570-a65a-547adb79c9c6 | kathryn.abby@gmail.com         | Katy_Abby
 9dfbcc4e-08a1-4dbf-a3c9-8b7ad86404b2 | katiereich@comcast.net         | ba1beed9-8ba8-437b-a1c7-567c37c54436
 f10f89d1-a525-49cf-960c-435604b54ba9 | katmarjo@gmail.com             | 0111c932-33d3-4d39-bea3-a289e3fa2d62
 270a679a-db0a-4d90-8fc3-977b5dd0d259 | kendrahinckley@gmail.com       | 7d418b20-d943-44dd-8a1c-436b783271f2
 d6ff91a7-d028-40b6-8cf3-329f14673e77 | kes.stewart9@gmail.com         | 2aa64b1c-61a8-406d-9a76-d41a826bb454
 5e08a168-7cda-483a-941c-da67856aee3b | kingram10@gmail.com            | 8ad56b18-b54f-477c-a1af-788bf8d067c1
 870c77d8-84ee-444b-b6a8-108bb4545cfc | kristian@rainstormtech.com     | ffec4098-6049-4f7f-97d6-7f07fc57064b
 9ce46fc6-10d8-4fb8-b91f-d0bb9b0625de | kristin@bluebusfoods.com       | Blue_Bus_Cultured_Foods

 564c5af8-0b5d-4f81-b1fe-bda99ed668a3 | l@a.com                        | liam
 d88a1456-e2ea-41d9-98d5-6f69a0368bf2 | l@a.com                        | Liam

 77a1108a-cca5-45c8-84c5-4f013d705df9 | lamo0654@pacificu.edu          | Dana_LaMonica
 bd8affee-13c6-4e55-bf60-05a018b85dfe | laura.khanna@icloud.com        | 2ebab631-23d4-45ca-a605-c04418238cfd

 434c2084-1463-4847-b034-b58eed21b5f3 | Lindajoy2001@hotmail.com       | Linda_Joy

 0bd00062-176a-414f-a71a-65a97061579e | lindsaythegroves@gmail.com     | 791a8bfd-1a4c-4453-a81d-e05b02e89f2e
 fd095dd3-948b-4cdd-928c-1c14c12f3d54 | lisa@lisahillpr.com            | f1531c0d-d293-484b-b462-82b06cfc8ab6
 6773d589-d148-421c-b4fe-729efe708e63 | lizmariegler@gmail.com         | Liz_Riegler
 5a8166b5-dd81-4925-96fa-a764a6a42f70 | liz.turner@gmail.com           | Liz_Turner
 4fb42fd2-900b-47b0-9a14-cb2a2586a891 | lola@umiorganic.com            | Lola_Milholland
 603910a4-f110-474f-9254-a79f7e42e89f | lolo1225@yahoo.com             | e0256f2c-3978-4fc9-8c36-68582291ca34
 614e6795-18b2-491b-9052-5895465e79e6 | Lsherlinger@hotmail.com        | f04644bc-e660-4509-8a46-0cb7ee2866e1
 bdb62288-912f-47d5-b2db-acca877545f7 | lynnl007@comcast.net           | c64ccb64-4e78-477c-a3be-10e73950ccc6
 90df9e65-6e38-42e3-a580-09851bf8db87 | madelinetomseth@gmail.com      | 0dfd9270-8606-486b-9597-a8d970a27e59
 75a6f3ca-b94b-4b3c-8426-cf8b30e2c4cb | maizeys@aol.com                | 6a07df99-eb0f-4b0a-9b70-df1a48efa4df
 7c8a30eb-178f-47f6-bd1e-64c19a9b70f6 | marazoom@gmail.com             | 5dc1d4d8-53b5-4188-bd2d-b913f8c52863
 82a89599-eaf3-42b3-a325-0f838cc7d4c7 | margaretckendall@me.com        | 5c694598-8e9d-463a-bfcf-f0a25454c888
 0377126f-4838-43f7-9b96-c96456e9ffa4 | maria.veltman@gmail.com        | Maria_Veltman
 0f5d7386-d964-495b-aef7-efe686205091 | mattniiro@gmail.com            | mattniiro
 c4283d82-f3c8-480b-8e96-3e1ab2de6a46 | mattrea01@comcast.net          | Matt_Rea
 734ec0cc-8eed-4538-87bd-66249ac60816 | Max517@gmail.com               | Max_Ginsburg
 80725e4d-c4d5-41e9-ba8a-416357140047 | Mcciva1@gmail.com              | 55b892fc-88b3-4810-a6d9-66981b60f4de
 26eb2d7b-742b-4196-ace6-4deedfa0c44d | mefpdx@yahoo.com               | 928aee30-9a3a-4ce8-a396-0877b04d36c8
 605634ae-0402-4c95-a37c-b85487d72a23 | memryhamik@gmail.com           | 667e3852-816d-4d4f-a06c-64a765cded5e
 b54b4109-603c-4a9f-a2c5-9924c4607553 | metalandmoss@gmail.com         | Metal_Moss
 0a6373d6-fd7a-468f-945b-0e1f76886d5a | michelle@stockpotco.com        | Michelle_Battista

 f2521c0e-42d0-44d8-bae4-8f670e1e96a8 | mike.d.collins@gmail.com       | mikey
 8bfa86bc-bfa4-4741-bbf4-ab453d418740 | mike.d.collins@gmail.com       | mike

 d8f1e8b7-e07d-4db5-a6b7-2a6ffb4a6fd2 | mo@franklinpr.com              | Melissa_Franklin
 e010d748-0c02-4d84-bb37-e93062cae15f | mollymbell@gmail.com           | 6dcbd9a7-f2e7-4fbb-9b0e-ec7d6925aead
 3dd582ed-1372-4c3a-8a7c-535bfa029951 | molly.picha@gmail.com          | 42286dff-77a1-4fed-90c8-dc3cf6c05676
 e40ef010-3d9d-456d-b3a5-09652f3bbbb3 | morganquist@gmail.com          | 4fa7e282-8bfd-4de1-a7e8-4565cd909be9
 e5e4e9ed-1741-4ebb-9e0f-cb2976560375 | mrargento@gmail.com            | Margaret_Switzer
 3cd2d19a-bf92-4d18-a6ce-01bb523dc220 | nicholekarn@gmail.com          | Nichole_Karn
 74ad7b03-011f-4ec5-b41b-067ec5f3d144 | nicole.lendo@gmail.com         | Nicole_Lendo
 16308a5f-fe82-461e-a692-2fee311fd9a7 | nikkimariaguerrero@gmail.com   | fbe0ec83-189d-4ac7-8601-4fe1da92837c
 04432bb0-c4d6-4ea3-917e-03db0e854f48 | Ninaleah@gmail.com             | 6fd2a503-6d98-40a3-b5f4-821a88db827c
 802189c2-b75b-4c25-84f7-ba4716e27b47 | njnelson2011@gmail.com         | Natalie_Nelson
 ffde8234-45d1-4f74-b1a3-c30152a7b98f | nwakeford@somage.com.au        | Nathan_Wakeford
 20785546-2ab5-416d-9363-592b9d6fd3c8 | ollie17@gmail.com              | Alia_DiOrio
 9b158cbc-8aeb-441e-a269-0b9b64e769ef | orders@bowerybagels.com        | Bowery_Bagels
 95890c56-bb4c-4356-b675-febbd44e4a72 | orders@cascadeorganic.com      | Cascade_Organic
 a3af6a78-cb9c-43ac-802c-9b4f8f7bf6fe | parlosnacks@gmail.com          | c90981bc-cf83-405e-8cca-29d8bcdd07f4
 6e027da9-c512-41c9-a8bf-0a67f5cb1879 | pdxcsk@gmail.com               | Tressa_Yellig
 214aafec-a18e-49fe-be77-4ebde17f2cdf | pskoon@gmail.com               | f176002b-4f20-4466-b740-33565570a7f0
 3f1358f9-0167-443f-8fd7-9e8f8c22d681 | radiobravery@gmail.com         | 9a901790-d265-4c63-9f4b-8465acb64f7a
 c7e92b9c-5338-46a4-8ebc-8af3ee362e5c | Raingarden123@gmail.com        | beff8750-2fdc-4d53-bb71-e9952f60fd01
 4ed4b3fa-6fee-4d58-98e9-f4d0bfe85915 | rc@cushnir.com                 | c64f4f07-d09e-43f8-859d-e3b7340f245e
 120df62e-4e8f-4c1b-bbcc-d3e75df871e5 | Rebecca.Hagmuller@gmail.com    | Rebecca_Hagmuller
 3399b297-b30c-4320-886a-82cbeabc4d26 | revelranch@gmail.com           | Revel_Ranch
 bf1a6ff1-0d3a-47f5-8acf-696ca7089dff | rmoshier@gmail.com             | Rachel_Adler
 d18d7001-a2ab-4b29-91f0-1588d30da418 | ryan@revelmeatco.com           | 4d9e94d6-4475-4ee9-a089-170c3c009dbf
 040a9ce8-89d9-4aef-b4f3-15a26b20fadd | sarah@briarrosecreamery.com    | Briar_Rose_Creamery
 77a1108a-cca5-45c8-84c5-4f013d705df9 | lamo0654@pacificu.edu          | Dana_LaMonica
 b05bd242-2ce3-404e-bf84-7f3b9db7f5c7 | sara.m.d@gmail.com             | e08fc6fb-06f8-435d-a0af-9961c5f3a8f2
 0fd9fe56-9ee6-41e7-be34-95d02e59d4ff | schneik80@gmail.com            | f1ba0812-c60e-4787-b187-20650afbf90f
 cd7b5ade-7ef7-11e7-bb31-be2e44b06b34 | scott@scottwerley.com          | Scott_Werley
 7004989a-c642-49b9-9731-0abf417ed210 | seidy_8@hotmail.com            | 6b461c26-6d54-4f92-a1d3-f63aa07bc9ac
 b5acedbd-d362-4801-951f-5be7f858aa33 | semaphoria@gmail.com           | fac90bfb-3d44-4340-a336-8e57bd2434ee
 8c200a4c-f53f-4e46-a5dd-bd745f596754 | shelly.whittington15@gmail.com | 67f2341b-ad68-44dd-84a7-3ff5b3203aa3
 8ab606d9-714d-4007-b323-b031febb1de2 | Skeena84@hotmail.com           | da0e3e79-5057-49f2-b99c-5ad256261401
 30feac1e-ac28-4851-9a2d-541613201425 | smelsaortega@gmail.com         | 2c14e424-b438-460a-ad1a-240c13ed80ce
 7c8c6b13-cf91-4935-a3ca-4ce2d3af33ad | Staceytloy@gmail.com           | 14eb7f24-2ba1-4292-a907-6c0f3b26d2e5
 7ec1f7bb-dc9a-4894-aa0e-2d6c345389ce | stacirutschman1969@gmail.com   | 99f62cb1-fe88-47c2-a97e-73d34838a9ba
 98053b7d-1a28-470a-bbed-9818eea68a96 | stellamacaroni@gmail.com       | 46635cd2-1e63-4bd7-8782-efe407225513
 332faf7f-729a-4701-9554-60e89d7b7aa5 | stosh.st@gmail.com             | cfbe2da5-649e-4abf-b0e0-cbf0413f0736
 022f9b88-95a5-4424-afc9-0f7e906288a2 | swaja17@gmail.com              | c7bb8e65-799b-4ed8-a81e-73ab710b0055
 8f4abf2d-bca5-4222-b3e4-eabfc530ca65 | tareva@gmail.com               | f2966cf9-3bd5-4228-ab8e-93dd7ea7bdca
 84f746cc-c7b4-45f5-9774-55246dc4ec43 | tawinterrowd@gmail.com         | Pitkin_Winterrowd_Farms
 38face79-8509-4b74-9f39-bf768e8ffa21 | tclosson@cherofflaw.com        | e4bacac3-7a15-46f6-b80f-ced684bb0ab4
 f860bf56-06db-4ce0-be7d-48fb9eb9dbab | teddya26@yahoo.com             | ac8b7e7e-4ad7-48c2-9077-1ebc3700f134
 62c3d3f1-2272-4cc4-b640-60a483415d12 | teesquaredpdx@gmail.com        | afcfc6ba-c5e4-479a-ae0d-ddfb517f46ee
 eadb62bd-451d-4e20-ad7e-7d0b8f3b4175 | tessastuedli@gmail.com         | bde169c3-dd05-4193-8ece-04f00c15460d
 bace67c7-e848-45fe-8dd6-251fc9b4c8e7 | the.di.carroll@gmail.com       | 4d375788-601b-4294-9fc3-39e5887a09bf
 cd7b587c-7ef7-11e7-bb31-be2e44b06b34 | trish.m.cannon@gmail.com       | Trish_Cannon
 e2fd07fc-0f55-4e1b-9b23-77da4723170c | twilar@gmail.com               | 8e999375-506d-4179-b31d-1f04420bb299
 c9f0e590-28ae-43b2-99fd-326f99cef6e1 | tyler.peterson@me.com          | 21bc2cf1-1312-43d8-84ce-607a25144091
 243ba1f1-e699-4a4d-a835-98cc261afdba | ulises@granobreads.com         | 6e4f37e6-f238-466b-b8ca-4e590c842577
 4a2ac6b9-baab-4c75-aed5-18ec21170e50 | urshg@hotmail.com              | Ursula_Garcia
 abf9df59-ae19-4023-9c32-024af2db53e2 | vanessa.margolis@gmail.com     | Vanessa_Margolis
 c5f8e279-cbbf-44c1-adad-0e6472ba3dc7 | v.mix@me.com                   | Virginia_Adatto
 37dc0681-99b6-4f4a-aa77-bed2f1d35db7 | wholesale@redridgefarms.com    | 7c2c72e3-0e1f-4201-afd0-454187ea5bc2
 9dcef5b8-d11b-4695-8c1f-0bda8be3ba35 | windsor.meyer@gmail.com        | 6b2fde44-25fc-4849-9ddc-ea2e68d7c9b0
 b21efee4-a9a3-4f24-b432-73974bf3047d | yesgallardo@gmail.com          | be196eaa-b7ee-42b5-91dc-1af03229a9e0
 bf69a105-1370-4e62-a96c-1b5adc49511e | yvonnefide@gmail.com           | 8593b086-3511-4f41-bb80-71ac58209c22


 edfe5bc0-3051-4276-9621-c89b2e56c217 | caldwellfamilyfarm@ymail.com   | e979e219-fc6e-47f9-af8d-3a499f7f2780
 86b10aeb-0633-4e48-9376-50152ff482e7 | caldwellfamilyfarm@ymail.com   | Kiyokawa_Orchard
 1bbdc97a-fb02-497f-8456-78f62f998132 | danielle.erin.lohr@gmail.com   | 471d7c8b-f66b-43e9-a893-be0eabc35037
 31159a10-e1e1-4d98-89e7-2a357adce37c | danielle.erin.lohr@gmail.com   | 4ea15e27-729e-46db-9361-98c7923d3a86
 59ddd387-b920-4720-87b5-4b1bd13c73c4 | evangregoirepdx@gmail.com      | Stargazer_Farm
 44689367-ddf1-4f0e-bf71-22ea7d796386 | evangregoirepdx@gmail.com      | Portland_Seedhouse
 4f841483-758c-4988-aa5b-81310b4f8a92 | Jang@mcewengisvold.com         | 8f8caf04-6437-4470-bbbe-99555d3e9460
 b3c2f211-c3f5-420b-af44-89f8d0b0cdc8 | Jang@mcewengisvold.com         | 48b6a920-edfc-4d9a-a8e4-4bd45cdf2fee
 5b2c8f94-4646-4c78-aa55-c78e3f7fef2f | john.cohoon@gmail.com          | be416353-d359-4fa8-9fbd-aee62c427360
 78b6c313-e46a-4742-a306-cecabf17ed74 | john.cohoon@gmail.com          | 2d7e758a-b9a8-4ebb-ad26-64dfc558f170
 1ac76001-8dc7-450d-9f27-d05864b8d61e | lamathubten@gmail.com          | thubten
 9f9933da-5cf0-4a79-87f0-70562f5e9495 | lamathubten@gmail.com          | Thubten_Comerford
 35705ea3-08be-40c4-9b9e-c8b982638f59 | ricksteffenfarm@gmail.com      | Rick__Steffen_Farm
 3a4e2d9b-35c8-4ecd-aaa6-cb1cf6ceed40 | ricksteffenfarm@gmail.com      | Rick_Steffen_Farm

login names that collide
 lindajoy2001@hotmail.com
 Lindajoy2001@hotmail.com
 steelchris23@gmail.com         | steelchris23
 Steelchris23@gmail.com         | Chris_Steel

dump of login names

 Abbie_Nelson
 Abby_Rutschman
 Alia_DiOrio
 Alli_Fodor
 amberdaggett@gmail.com
 amber@localmilkrun.com
 Amey_Wilkinson
 Ami_Lindsey
 Amy_Chamberlain_Torres
 Amye_Scavarda
 Amy_Hillman
 Amy_Maroney
 amy.maroney@gmail.com
 Amy_Ramage
 ARamage
 asa@tinycreative.com
 Ayers_Creek_Farm
 Baird_Family_Farm
 Barb_Meyer
 Barnypok
 Ben_Jenkins
 Beta_Hatch
 Bliss_Nut_Butters
 Blue_Bus_Cultured_Foods
 Bowery_Bagels
 Brandy_Faist
 Briar_Rose_Creamery
 brunch@trinketpdx.com
 cakewalkbaking@aol.com
 Caroline_Bergstrom
 Carrie_Young
 Cascade_Organic
 Chad_Ledson
 Charlene_Bjorklund
 Chef_Kit
 Chicken_Scratch_Farm
 Chris_Serin
 chrisserlin@gmail.com
 Chris_Steel
 Christine_Maynard
 Chris_Wilhite
 cody@cascadeorganic.com
 Connor_Martin
 Coquine
 Courtney_Davies
 Cristen_Lincoln
 Dana_LaMonica
 daniellbliss@gmail.com
 Danielle_George
 Danielle_Hubbard
 Danielle_Lohr
 Daniell_Lohr
 Dawn_Bolgioni
 DeAnna_Haase
 Deidra_Trusley
 Dennis_Kambury
 DeNoble_Farms
 Diana_Carroll
 dsmcgraw18@gmail.com
 dunja@ecodistricts.org
 eaterOne
 eaters@localmilkrun.com
 efschnei@yahoo.com
 Even_Pull_Farm
 feederOne
 Garys_Milk
 Gathering_Together_Farm
 gregorymc@gmail.com
 Gregory_McManis
 Heather_Thordarson
 Heather_Warman
 Hot_Mamas_Salsa
 iamathubten@gmail.com
 Jackie_Bartlett
 Jacobs_Creamery
 James_Keller
 James_Serlin
 Jamie_Le
 Jang@mcewengisvold.com
 Jan_Gravdal
 Jen_Johnson
 Jennifer_Bryman
 Jessica_Wheelock
 Jill_Collins
 JimmiXzSq
 jle808
 jnhusker@mac.com
 Jodie_Ostrovsky
 Johanna_Blackford
 John_Cohoon
 john.cohoon@gmail.com
 John_Evons
 Jon_Maroney
 jon@oregonangelfund.com
 Julia
 k8rouse@gmail.com
 kajaglickenhaus@yahoo.com
 Kaja_Taft
 Kaley_Rutschman
 Karen_Foreman
 Kate_DuHadway
 Kate_Koff
 Katherine_Johnson
 Kathleen_Bauer
 katiereich@comcast.net
 Katy_Abby
 kendrahinckley@gmail.com
 kes.stewart9@gmail.com
 Kim_Collins
 kingram10@gmail.com
 Kiyokawa_Orchard
 lamathubten@gmail.com
 lamo0654@pacificu.edu
 Lardo
 Laura_Khanna
 Laurelhurst_Market
 Leah_Scafe
 Let_Um_Eat_Farm
 liam
 Liam
 Linda_Joy
 Lindsay_Groves
 Lisa_Herlinger
 Lisa_Hill
 Lisa_Mattila
 Lisa_Parnell
 Liz_Riegler
 Liz_Turner
 liz.turner@gmail.com
 Lola_Milholland
 Lori_Idsinga
 lynnl007@comcast.net
 Madeline_Tomseth
 madelinetomseth@gmail.com
 Magen_Gulliford
 Margaret_Alvarez
 margaretckendall@me.com
 Margaret_Foley
 Margaret_Switzer
 Maria_Veltman
 Marissa_Anderson
 MaryHill_Farm
 mattniiro
 Matt_Rea
 max517@gmail.com
 Max517@gmail.com
 Max_Ginsburg
 Mcciva1@gmail.com
 McKenzie_Ingram
 Melissa_Franklin
 Memry_Smith
 Metal_Moss
 Michelle_Battista
 Michelle_Herman
 mike
 mike.d.collins@gmail.com
 mike@localmilkrun.com
 mikey
 Mindy_Hoffman
 Mo_Bettah_Honey
 Molly_Bell
 Molly_Picha
 Morgan_Lundquist
 Natalie_Grunkemeier
 Natalie_Nelson
 Nathan_Wakeford
 Nichole_Karn
 Nicole_Hargrave
 Nicole_Lendo
 nicole.lendo@gmail.com
 Ninaleah@gmail.com
 Old_Salt_Marketplace
 ollie17@gmail.com
 Our_Table_Cooperative
 parlosnacks@gmail.com
 Pasta_Gardner
 Patricia_Koon
 pdxcsk@gmail.com
 Pitkin_Winterrowd_Farms
 Portland_Seedhouse
 Rachel_Adler
 radiobravery@gmail.com
 Rain_Rezendes
 Ramage_Farm
 Raphael_Cushnir
 Rebecca_Hagmuller
 Rebecca.Hagmuller@gmail.com
 redapollos
 Revel_Meat_Co
 Revel_Ranch
 Rick__Steffen_Farm
 Rick_Steffen_Farm
 Rucksack_Roasting_Co
 Salt_Fire_Time
 Sarah_Dickman
 Sarah_Mooney
 schneik80@gmail.com
 scott@scottwerley.com
 Scott_Werley
 Scratch_Farms
 seidy_8@hotmail.com
 semaphoria@gmail.com
 Shannon_Shrock
 Shelly_Whittington
 Simington_Gardens
 smelsaortega@gmail.com
 Smith_Tea
 Stacey_Tigner_Loy
 Staci_Lewis
 Stargazer_Farm
 Starvation_Alley
 steelchris23
 stellamacaroni@gmail.com
 Stephen_Emery
 stosh.st@gmail.com
 Stumptown_Coffee
 swaja17@gmail.com
 Tareva_Domini
 teddya26@yahoo.com
 teesquaredpdx@gmail.com
 tessastuedli@gmail.com
 thubten
 Thubten_Comerford
 Timber_City
 Timber_City_Ginger
 Tonia_Closson
 Travis_Cannon
 Tressa_Yellig
 Trish_Cannon
 trish.m.cannon@gmail.com
 Twila_Raftu
 Tyler_Peterson
 ulises@granobreads.com
 Umi_Organic
 Union_Yeast_Grain
 Ursula_Garcia
 Vanessa_Margolis
 vanessa.margolis@gmail.com
 Vibrant_Valley_Farm
 Virginia_Adatto
 wholesale@redridgefarms.com
 Windsor_Meyer
 windsor.meyer@gmail.com
 Woodblock_Chocolate
 yesgallardo@gmail.com
 Yvonne_Fide

 */